import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as geo;


class CameraQr extends StatefulWidget {
  const CameraQr({Key? key});

  @override
  State<CameraQr> createState() => CameraQrState();
}

class CameraQrState extends State<CameraQr> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _requestPermissions();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
    ].request();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpline'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CameraScreen(cameraController: _cameraController),
              ),
            );
          },
          child: const Text('Get help!'),
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;

  const CameraScreen({Key? key, required this.cameraController})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isImageMode = true; // Default to image mode
  bool _isRecording = false; // Track if video recording is in progress
  late Future<void> _initializeControllerFuture;
  bool _isUploading = false; // Track if the media is uploading
  int _videoDurationSeconds = 0; // Track the duration of the recorded video

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = widget.cameraController.initialize();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(widget.cameraController);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (_isUploading)
            CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.5),
              strokeWidth: 3,
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _isUploading ? null : _captureImage,
                      icon: const Icon(Icons.camera_alt),
                      iconSize: 48,
                      color: Colors.black,
                    ),
                    IconButton(
                      onPressed: _isUploading ? null : _toggleRecording,
                      icon: Icon(_isRecording ? Icons.stop : Icons.videocam),
                      iconSize: 48,
                      color: Colors.black,
                    ),
                  ],
                ),
                if (_isRecording)
                  Text(
                    'Duration: $_videoDurationSeconds s',
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _captureImage() async {
    setState(() {
      _isImageMode = true;
      _isUploading = true;
    });

    try {
      XFile? imageFile = await widget.cameraController.takePicture();

      if (imageFile != null) {
        Position position = await _getCurrentLocation();
        String imageUrl = await _uploadImageToStorage(File(imageFile.path));
        String address = await _getAddressFromCoordinates(
            position.latitude, position.longitude);

        await _uploadDataToFirestore(imageUrl, position, address);

        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      print("Error capturing image: $e");
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _toggleRecording() async {
    if (!_isRecording) {
      setState(() {
        _isRecording = true;
        _isUploading = true;
      });

      try {
        // Start video recording without expecting a return value
        await widget.cameraController.startVideoRecording();

        // Update UI to indicate recording
        setState(() {
          _isUploading = false;
        });
      } catch (e) {
        print("Error recording video: $e");
        setState(() {
          _isRecording = false;
          _isUploading = false;
        });
      }
    } else {
      setState(() {
        _isRecording = false;
        _isUploading = false;
      });
      XFile? videoFile = await widget.cameraController.stopVideoRecording();

      if (videoFile != null) {
        Position position = await _getCurrentLocation();
        String videoUrl = await _uploadVideoToStorage(File(videoFile.path));
        String address = await _getAddressFromCoordinates(
            position.latitude, position.longitude);

        await _uploadDataToFirestore(videoUrl, position, address);

        setState(() {
          _videoDurationSeconds = 0; // Reset video duration after uploading
        });
      }
    }
  }

  Future<void> _startTimer() async {
    while (_isRecording) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _videoDurationSeconds++;
      });
    }
  }

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('logs/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      return '';
    }
  }

  Future<String> _uploadVideoToStorage(File videoFile) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('logs/${DateTime.now().millisecondsSinceEpoch}.mp4');
      final UploadTask uploadTask = storageReference.putFile(videoFile);
      final TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      final String videoUrl = await taskSnapshot.ref.getDownloadURL();
      return videoUrl;
    } catch (e) {
      print("Error uploading video to Firebase Storage: $e");
      return '';
    }
  }

  Future<void> _uploadDataToFirestore(
    String mediaUrl, Position position, String address) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final mobileNumber = user!.phoneNumber;

    String randomId = DateTime.now().millisecondsSinceEpoch.toString();

    // Fetch user's complete details
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(mobileNumber)
        .collection('loginDetails')
        .doc(mobileNumber)
        .get();
    Map<String, dynamic>? userData =
        userDataSnapshot.data() as Map<String, dynamic>?;

    // Upload data to Firestore for the user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(mobileNumber)
        .collection('logs')
        .doc(randomId)
        .set({
      'mediaLink': mediaUrl,
      'address': address,
      'type': _isImageMode ? 'image' : 'video',
      'duration_seconds': _isImageMode ? null : _videoDurationSeconds,
      // Include user's details in Firestore document
      'user_details': userData,
      // Include Google Maps URL
      'google_maps_url': 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
    });

    // Fetch emergency contact's details
    String emergencyContact = userData?['emergencyContact'] ?? '';
    DocumentSnapshot emergencyContactDataSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(emergencyContact) // Use emergency contact as the document ID
        .collection('loginDetails')
        .doc(emergencyContact)
        .get();
    Map<String, dynamic>? emergencyContactData =
        emergencyContactDataSnapshot.data() as Map<String, dynamic>?;

    // Upload data to Firestore for the emergency contact
    await FirebaseFirestore.instance
        .collection('users')
        .doc(emergencyContact)
        .collection('logsForEmergencyContact')
        .doc(randomId)
        .set({
      'mediaLink': mediaUrl,
      'address': address,
      'type': _isImageMode ? 'image' : 'video',
      'duration_seconds': _isImageMode ? null : _videoDurationSeconds,
      // Include user's details in Firestore document
      'user_details': userData,
      // Include Google Maps URL
      'google_maps_url': 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
    });

    // Send a text message to the emergency contact
    String token = Uri.parse(mediaUrl).queryParameters['token'] ?? '';
    String formattedMediaUrl = mediaUrl + '?alt=media&token=$token';
    print('Formatted Media URL: $formattedMediaUrl');
    print('Address: $address');
    print('Google Maps URL: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}');


    // Send a text message to the emergency contact
   String message =
    "Help! I need assistance. Here's the link to the media: ${Uri.encodeQueryComponent(formattedMediaUrl)}. My current location: $address. Google Maps Location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";


    String phoneNumber = emergencyContact;
    if (phoneNumber.isNotEmpty) {
      final uri = 'sms:$phoneNumber?body=${Uri.encodeQueryComponent(message)}';
      try {
        await launch(uri);
      } catch (e) {
        print("Error launching SMS: $e");
        throw 'Could not launch SMS';
      }
    } else {
      throw 'Emergency contact number is invalid';
    }

    Navigator.pop(context);
  } catch (e) {
    print("Error uploading data to Firestore: $e");
  }
}


  Future<String> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<geo.Placemark> placemarks =
          await geo.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final geo.Placemark placemark = placemarks.first;
        return '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country} - ${placemark.postalCode ?? ''}';
      } else {
        return 'Unknown location';
      }
    } catch (e) {
      print('Error fetching location: $e');
      return 'Unknown location';
    }
  }
}
