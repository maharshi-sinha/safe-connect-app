import 'dart:convert'; // Import the 'dart:convert' library
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:safe_connect/bottomNavBar.dart';
import 'package:safe_connect/screens/HomeScreen/homeScreen.dart';
import 'package:safe_connect/theme.dart';

class MedicalInformationPage extends StatefulWidget {
  @override
  _MedicalInformationPageState createState() => _MedicalInformationPageState();
}

class _MedicalInformationPageState extends State<MedicalInformationPage> {
  String? _bloodType;
  String? _bloodPressure;
  String? _allergies;
  String? _medications;
  bool _isOrganDonor = false;
  String? _medicalNotes;
  String? _disease;
  String? _immunizations;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bloodPressureController =
      TextEditingController();

  String? jsonUrl; // URL of hosted JSON file

  @override
  void initState() {
    super.initState();
    _bloodPressureController.addListener(_formatBloodPressure);
  }

  @override
  void dispose() {
    _bloodPressureController.removeListener(_formatBloodPressure);
    _bloodPressureController.dispose();
    super.dispose();
  }

  void _formatBloodPressure() {
    String text = _bloodPressureController.text;
    if (text.length == 3 && !_bloodPressureController.text.contains('/')) {
      _bloodPressureController.text = '$text/';
      _bloodPressureController.selection = TextSelection.fromPosition(
          TextPosition(offset: _bloodPressureController.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => bottomNavigationBar()),
              );
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)),
        title: Text(
          'Medical Information',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medical Registration',
                    style: TextStyle(
                      color: Color(0xffFFB13D),
                      fontFamily: 'Gilroy',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Fill out this registration form & generate the QR',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              DropdownButtonFormField<String>(
                value: _bloodType,
                onChanged: (String? newValue) {
                  setState(() {
                    _bloodType = newValue;
                  });
                },
                items: <String>[
                  'A+',
                  'A-',
                  'B+',
                  'B-',
                  'AB+',
                  'AB-',
                  'O+',
                  'O-'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Blood Type',
                  labelStyle:
                      TextStyle(fontFamily: 'gilroy', color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select blood type';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black, fontFamily: 'gilroy'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _bloodPressureController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Blood Pressure (mmHg)',
                  labelStyle:
                      TextStyle(color: Colors.white, fontFamily: 'gilroy'),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  _bloodPressure = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter blood pressure';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Allergies',
                  labelStyle:
                      TextStyle(color: Colors.white, fontFamily: 'gilroy'),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  _allergies = value;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontFamily: 'gilroy'),
                decoration: InputDecoration(
                  labelText: 'Medications',
                  labelStyle:
                      TextStyle(fontFamily: 'gilroy', color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  _medications = value;
                },
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text(
                    'Organ Donor:',
                    style: TextStyle(fontFamily: 'gilroy', color: Colors.white),
                  ),
                  Checkbox(
                    value: _isOrganDonor,
                    activeColor: Colors.transparent,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          _isOrganDonor = value;
                        });
                      }
                    },
                    checkColor: Color(0xffFFB13D),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              TextFormField(
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Medical Notes',
                  labelStyle:
                      TextStyle(color: Colors.white, fontFamily: 'gilroy'),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  _medicalNotes = value;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontFamily: 'gilroy'),
                decoration: InputDecoration(
                  labelText: 'Disease',
                  labelStyle:
                      TextStyle(color: Colors.white, fontFamily: 'gilroy'),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  _disease = value;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Immunizations',
                  labelStyle: TextStyle(
                    fontFamily: 'gilroy',
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                onChanged: (value) {
                  _immunizations = value;
                },
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Color(0xffFFB13D),
                ),
                onPressed: () async {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      final mobileNumber = user!.phoneNumber;

                      // Create a Map to store the medical information
                      Map<String, dynamic> medicalInfo = {
                        'bloodType': _bloodType,
                        'bloodPressure': _bloodPressure,
                        'allergies': _allergies,
                        'medications': _medications,
                        'isOrganDonor': _isOrganDonor,
                        'medicalNotes': _medicalNotes,
                        'disease': _disease,
                        'immunizations': _immunizations,
                      };

                      // Convert the Map to JSON
                      String jsonData = json.encode(medicalInfo);

                      // Send medical information to Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(mobileNumber)
                          .collection('medicalInformation')
                          .doc(mobileNumber)
                          .set(medicalInfo);

                      // Save data to Firebase Storage
                      final storageRef = FirebaseStorage.instance
                          .ref()
                          .child('registeredVehicles/$mobileNumber.json');
                      await storageRef
                          .putString(jsonData)
                          .whenComplete(() => print('Data Uploaded'));

                      // Retrieve the URL of the hosted JSON file
                      String url = await storageRef.getDownloadURL();
                      setState(() {
                        jsonUrl = url; // Set the URL to the state
                      });

                      // Show success dialog with URL
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Success'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Medical information saved successfully!'),
                                SizedBox(height: 10),
                                Text('URL: $url'), // Display URL
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Clear form fields
                                  _formKey.currentState?.reset();
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      print('Error saving medical information: $e');
                    }
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.black, fontFamily: 'gilroy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
