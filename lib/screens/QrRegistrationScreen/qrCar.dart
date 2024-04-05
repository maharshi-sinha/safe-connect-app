import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({Key? key}) : super(key: key);

  @override
  _QRGeneratorState createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _emergencyContactNoController =
      TextEditingController();
  String _qrData = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                    child: Text("Car Registration",
                        style: TextStyle(fontSize: 15.0))),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Remove non-alphabetic characters and allow space
                    _nameController.value = _nameController.value.copyWith(
                      text: value.replaceAll(RegExp(r'[^a-zA-Z\s]'), ''),
                      selection: TextSelection.collapsed(offset: value.length),
                      composing: TextRange.empty,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _vehicleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Brand and Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.text, // Change keyboardType to text
                  onChanged: (value) {
                    // Remove non-alphabetic and non-numeric characters
                    _vehicleNameController.value =
                        _vehicleNameController.value.copyWith(
                      text: value.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ''),
                      selection: TextSelection.collapsed(offset: value.length),
                      composing: TextRange.empty,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _vehicleNoController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle No.',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 10, // Set maximum length to 10 characters
                  onChanged: (value) {
                    // Convert input to uppercase, remove non-alphabetic and non-numeric characters, and limit to 10 characters
                    _vehicleNoController.value =
                        _vehicleNoController.value.copyWith(
                      text: value
                          .toUpperCase()
                          .replaceAll(RegExp(r'[^A-Z0-9]'), '')
                          .substring(0, 10),
                      selection: TextSelection.collapsed(offset: value.length),
                      composing: TextRange.empty,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.emailAddress, // Set keyboard type to email
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!_isValidEmailFormat(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _contactNoController,
                  decoration: const InputDecoration(
                    labelText: 'Contact No.',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.phone, // Set keyboard type to phone
                  maxLength: 10, // Set maximum length to 10 digits
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Allow only digits
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emergencyContactNoController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact No.',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      TextInputType.phone, // Set keyboard type to phone
                  maxLength: 10, // Set maximum length to 10 digits
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Allow only digits
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // backgroundColor: Color(0xFF3199E4),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: _onGenerateQRPressed,
                        child: const Text(
                          'Generate QR Code',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: SizedBox(
                        height: 40.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: const Color(0xFF3199E4),
                          ),
                          onPressed: () async {
                            if (_qrData.isNotEmpty) {
                              await _saveQrImage();
                            }
                          },
                          child: const Text(
                            'Download QR',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          child: QrImageView(
                            data: _qrData,
                            version: QrVersions.auto,
                            size: 150.0,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Download this QR code and stick it on the front and backside of your car',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onGenerateQRPressed() async {
    if (_formKey.currentState!.validate()) {
      await _saveDataToFirestore(); // Save data to Firestore
      await _generateQRFromFirestoreData(); // Generate QR code from Firestore data
    } else {
      // Show alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Form Error"),
            content: const Text("Please fill the form correctly."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _generateQRFromFirestoreData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final carNumber = _vehicleNoController.text;

      final documentSnapshot = await FirebaseFirestore.instance
          .collection('registeredVehicles')
          .doc(carNumber)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _qrData =
              'Name: ${data['name']}, Vehicle Brand & Name: ${data['vehicleName']}, Vehicle No.: ${data['vehicleNumber']}, Email: ${data['email']}, Contact No.: ${data['contactNumber']}, Emergency Contact No.: ${data['emergencyContact']}';
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _saveDataToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final mobileNumber = user!.phoneNumber;
      final carNumber = _vehicleNoController.text;

      // Check if the car number already exists in Firestore
      final existingDoc = await FirebaseFirestore.instance
          .collection('registeredVehicles')
          .doc(carNumber)
          .get();

      if (existingDoc.exists) {
        // Vehicle is already registered
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Vehicle Already Registered"),
              content: const Text("This vehicle is already registered."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // Vehicle is not registered, proceed to save data
        await FirebaseFirestore.instance
            .collection('registeredVehicles')
            .doc(carNumber)
            .set({
          'name': _nameController.text,
          'vehicleName': _vehicleNameController.text,
          'vehicleNumber': _vehicleNoController.text,
          'email': _emailController.text,
          'contactNumber': int.parse(_contactNoController.text),
          'emergencyContact': int.parse(_emergencyContactNoController.text),
        });

        // Also save data to the additional collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(mobileNumber)
            .collection('registeredQr')
            .doc(carNumber)
            .set({
          'name': _nameController.text,
          'vehicleName': _vehicleNameController.text,
          'vehicleNumber': _vehicleNoController.text,
          'email': _emailController.text,
          'contactNumber': int.parse(_contactNoController.text),
          'emergencyContact': int.parse(_emergencyContactNoController.text),
        });

        setState(() {
          _qrData =
              'Name: ${_nameController.text}, Vehicle Brand & Name: ${_vehicleNameController.text}, Vehicle No.: ${_vehicleNoController.text}, Email: ${_emailController.text}, Contact No.: ${_contactNoController.text}, Emergency Contact No.: ${_emergencyContactNoController.text}';
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

Future<void> _saveQrImage() async {
  try {
    final image = await QrPainter(
      data: _qrData,
      version: QrVersions.auto,
      gapless: false,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
    ).toImageData(300);

    final user = FirebaseAuth.instance.currentUser;
    final vehicleNumber = _vehicleNoController.text; 
    
    final storageRef = FirebaseStorage.instance.ref().child('qr_codes').child('${user!.uid}_qr_code_$vehicleNumber.png');
    
    final UploadTask uploadTask = storageRef.putData(image!.buffer.asUint8List());

    await uploadTask.whenComplete(() => print('QR code image uploaded'));
    final String downloadURL = await storageRef.getDownloadURL();

    await launch(downloadURL);
  } catch (e) {
    print('Error saving QR code image: $e');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Error saving QR code image: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleNameController.dispose();
    _vehicleNoController.dispose();
    _emailController.dispose();
    _contactNoController.dispose();
    _emergencyContactNoController.dispose();
    super.dispose();
  }

  bool _isValidEmailFormat(String email) {
    // Regular expression for email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
