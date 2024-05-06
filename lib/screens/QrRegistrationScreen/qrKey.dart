import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_connect/bottomNavBar.dart';
import 'package:safe_connect/screens/HomeScreen/homeScreen.dart';

class KeyRegistration extends StatefulWidget {
  const KeyRegistration({super.key});

  @override
  State<KeyRegistration> createState() => _KeyRegistrationState();
}

class _KeyRegistrationState extends State<KeyRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keyDescriptionController =
      TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _emergencyContactNoController =
      TextEditingController();

  bool _imageUploaded = false;
  String? _keyTypeController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => bottomNavigationBar()));
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text('Registration',
            style: TextStyle(
              fontFamily: 'gilroy',
              fontSize: 16.0,
              color: Colors.white,
            )),
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
                  'Key Registration',
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
                    labelText: 'Owner Name',
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
                Container(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Key Type',
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
                    value: _keyTypeController,
                    items: ['Bike Key', 'Car Key', 'House key', 'Other']
                        .map((String value) {
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
                        _keyTypeController = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: _keyDescriptionController,
                  decoration: const InputDecoration(
                    labelText: ' Key Description',
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
                    _keyDescriptionController.value =
                        _keyDescriptionController.value.copyWith(
                      text: value.replaceAll(RegExp(r'[^a-zA-Z\s]'), ''),
                      selection: TextSelection.collapsed(offset: value.length),
                      composing: TextRange.empty,
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  controller: _serialNoController,
                  decoration: const InputDecoration(
                    labelText: 'Key Serial No.',
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
                  // keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 20.0,
                ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 45,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _uploadImage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Color(0xffFFB13D),
                    ),
                    child: const Text(
                      'Upload Image',
                      style: TextStyle(
                        fontFamily: 'gilroy',
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                if (_imageUploaded)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Your image has been successfully uploaded', // Display this message
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'gilroy',
                          fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                  ),
                SizedBox(height: 40),
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
                    onPressed: () {
                      print('the button is pressed');
                    },
                    child: const Text(
                      'Generate QR Code',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        _imageUploaded = true;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = picked.toString().substring(0, 10);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _keyDescriptionController.dispose();
    _serialNoController.dispose();
    _contactNoController.dispose();
    _emergencyContactNoController.dispose();
    super.dispose();
  }
}

bool _isValidEmailFormat(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}
