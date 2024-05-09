import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

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
  bool _showQRData = false;
  String? _selectedVehicleType;
  String? _qrCodeUrl; // Added to store the QR code URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
        title: Text(
          'Registration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Vehicle Registration',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffFFB13D),
                    fontFamily: 'Gilroy',
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Fill out this registration form & generate the QR',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Gilroy',
                  ),
                ),
                SizedBox(height: 40.0),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
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
                SizedBox(height: 20),
                // Vehicle type dropdown
                Container(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Vehicle Type',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    value: _selectedVehicleType,
                    items: ['Car', 'Electric Car', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    style: TextStyle(color: Colors.white), // Set text color
                    dropdownColor:
                        Colors.black, // Set dropdown background color
                    onChanged: (String? value) {
                      setState(() {
                        _selectedVehicleType = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Brand and Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
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
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: _vehicleNoController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle No.',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  maxLength: 10,
                  onChanged: (value) {
                    // Convert input to uppercase and remove non-alphabetic and non-numeric characters
                    String processedValue = value
                        .toUpperCase()
                        .replaceAll(RegExp(r'[^A-Z0-9]'), '');

                    // Ensure the processed value doesn't exceed the maximum length of 10 characters
                    if (processedValue.length > 10) {
                      processedValue = processedValue.substring(0, 10);
                    }

                    // Update the controller value
                    _vehicleNoController.value =
                        _vehicleNoController.value.copyWith(
                      text: processedValue,
                      selection: TextSelection.collapsed(
                          offset: processedValue.length),
                      composing: TextRange.empty,
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: _contactNoController,
                  decoration: const InputDecoration(
                    labelText: 'Contact No.',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: _emergencyContactNoController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact No.',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.length == 10) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40.0),
                // Generate QR Button
                Container(
                  width: MediaQuery.of(context).size.width - 45,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Color(0xffFFB13D),
                    ),
                    onPressed: _onGenerateQRPressed,
                    child: const Text(
                      'Generate QR Code',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'gilroy'),
                    ),
                  ),
                ),
                if (_showQRData)
                  Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(0.0),
                                child: _qrCodeUrl != null
                                    ? Image.network(
                                        _qrCodeUrl!, // Use the stored URL
                                        height: 120,
                                        width: 120,
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Stay Connected to loved ones Download the QR for ${_vehicleNoController.text}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: 'Gilroy',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 45,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: const Color(0xffFF3D3D),
                                ),
                                onPressed: _onDownloadQrPressed,
                                child: const Text(
                                  'Click to download QR',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Display QR Code Image from URL
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
      await _sendPostRequest(); // Send POST request
      setState(() {
        _showQRData = true; // Set _showQRData to true when QR data is generated
      });
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

      final vehicleDoc = await FirebaseFirestore.instance
          .collection('registeredVehicles')
          .doc(carNumber)
          .get();

      final medicalDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.phoneNumber)
          .collection('medicalInformation')
          .doc(user.phoneNumber)
          .get();

      if (vehicleDoc.exists && medicalDoc.exists) {
        final vehicleData = vehicleDoc.data() as Map<String, dynamic>;
        final medicalData = medicalDoc.data() as Map<String, dynamic>;

        setState(() {
          _qrData =
              'Name: ${vehicleData['name']}, Vehicle Brand & Name: ${vehicleData['vehicleName']}, Vehicle No.: ${vehicleData['vehicleNumber']}, Email: ${vehicleData['email']}, Contact No.: ${vehicleData['contactNumber']}, Emergency Contact No.: ${vehicleData['emergencyContact']}, Blood Type: ${medicalData['bloodType']}, Blood Pressure: ${medicalData['bloodPressure']}, Allergies: ${medicalData['allergies']}, Medications: ${medicalData['medications']}, Organ Donor: ${medicalData['isOrganDonor']}, Medical Notes: ${medicalData['medicalNotes']}, Disease: ${medicalData['disease']}, Immunizations: ${medicalData['immunizations']}, QRCategory: Motor';
        });

        // Save data to Firebase Storage in JSON format
        final jsonData = {
          'name': vehicleData['name'],
          'vehicleName': vehicleData['vehicleName'],
          'vehicleNumber': vehicleData['vehicleNumber'],
          'email': vehicleData['email'],
          'contactNumber': vehicleData['contactNumber'],
          'emergencyContact': vehicleData['emergencyContact'],
          'bloodType': medicalData['bloodType'],
          'bloodPressure': medicalData['bloodPressure'],
          'allergies': medicalData['allergies'],
          'medications': medicalData['medications'],
          'isOrganDonor': medicalData['isOrganDonor'],
          'medicalNotes': medicalData['medicalNotes'],
          'disease': medicalData['disease'],
          'immunizations': medicalData['immunizations'],
          'QRCategory': 'Motor',
        };

        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('registeredVehicles')
            .child(carNumber + '.json');

        final jsonStr = json.encode(jsonData);
        await storageRef.putString(jsonStr);
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
        // Convert dropdown value to text
        String vehicleTypeText = '';
        if (_selectedVehicleType == 'Two Wheeler') {
          vehicleTypeText = 'Two Wheeler';
        } else if (_selectedVehicleType == 'Four Wheeler') {
          vehicleTypeText = 'Four Wheeler';
        } else {
          vehicleTypeText = 'Other';
        }

        // Vehicle is not registered, proceed to save data
        await FirebaseFirestore.instance
            .collection('registeredVehicles')
            .doc(carNumber)
            .set({
          'name': _nameController.text,
          'vehicleName': _vehicleNameController.text,
          'vehicleNumber': _vehicleNoController.text,
          'vehicleType': vehicleTypeText,
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
          'vehicleType': vehicleTypeText,
          'email': _emailController.text,
          'contactNumber': int.parse(_contactNoController.text),
          'emergencyContact': int.parse(_emergencyContactNoController.text),
          'QRCategory': 'Motor',
        });

        setState(() {
          _qrData =
              'Name: ${_nameController.text}, Vehicle Brand & Name: ${_vehicleNameController.text}, Vehicle No.: ${_vehicleNoController.text}, Vehicle Type: $vehicleTypeText, Email: ${_emailController.text}, Contact No.: ${_contactNoController.text}, Emergency Contact No.: ${_emergencyContactNoController.text}, QRCategory: Motor';
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _sendPostRequest() async {
    try {
      final url =
          'https://safeconnect-e81248c2d86f.herokuapp.com/vehicle/post_vehicle_data';

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'owner_name': _nameController.text,
          'vehicle_type': _selectedVehicleType,
          'vehicle_brand': _vehicleNameController.text,
          'vehicle_no': _vehicleNoController.text,
          'email': _emailController.text,
          'contact_number': _contactNoController.text,
          'emergency_number': _emergencyContactNoController.text,
        }),
      );

      final responseData = jsonDecode(response.body);
      print(responseData);

      // Retrieve the QR code URL from the response body
      final qrcodeUrl = responseData['data']['qrcode_url'];

      setState(() {
        _qrCodeUrl = qrcodeUrl; // Store the QR code URL
      });
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }

  Future<void> _saveQrImage() async {
    try {
      final image = await QrPainter(
        data: _qrData,
        version: QrVersions.auto,
        gapless: false,
        color: const Color(0xFFFFFFFF),
        emptyColor: const Color(0xFF000000),
      ).toImageData(300);

      final directory = await getExternalStorageDirectory();
      final imagePath =
          '${directory!.path}/qr_code_${_vehicleNoController.text}.png';

      await File(imagePath).writeAsBytes(image!.buffer.asUint8List());

      await ImageGallerySaver.saveFile(imagePath);

      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('qr_codes')
          .child('qr_code_${_vehicleNoController.text}.png');

      await storageRef.putFile(File(imagePath));

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text(
                'QR code image saved successfully for ${_vehicleNoController.text}'),
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

  Future<void> _onDownloadQrPressed() async {
    if (_qrData.isNotEmpty) {
      await _saveQrImage();
    }
  }

  bool _isValidEmailFormat(String email) {
    // Regular expression for email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
