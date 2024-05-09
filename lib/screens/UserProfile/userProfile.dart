import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:safe_connect/bottomNavBar.dart';
import 'package:safe_connect/screens/LoginScreen/loginScreen.dart';
import 'package:safe_connect/screens/SearchVehicle/searchVehicle.dart';
import 'package:shimmer/shimmer.dart';
import 'QRDetailspage.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();

  late User? user;
  late String mobileNumber;
  bool isEditMode = false;
  bool showDeleteButton = false;
  Map<String, dynamic> registeredQrDetails = {};
  bool showRegisteredQr = false;
  bool isLoadingQrDetails = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    mobileNumber = user!.phoneNumber!;
    _fetchUserData();
    _fetchRegisteredQrDetails();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(mobileNumber)
        .collection('loginDetails')
        .doc(mobileNumber)
        .get();

    Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

    setState(() {
      _nameController.text = userData?['name'] ?? '';
      _emailController.text = userData?['email'] ?? '';
      _emergencyContactController.text = userData?['emergencyContact'] ?? '';
    });
  }

  Future<void> _fetchRegisteredQrDetails() async {
    setState(() {
      isLoadingQrDetails = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(mobileNumber)
        .collection('registeredQr')
        .get();

    if (snapshot.docs.isNotEmpty) {
      registeredQrDetails.clear();
      snapshot.docs.forEach((doc) {
        registeredQrDetails[doc.id] = doc.data();
      });
      setState(() {
        isLoadingQrDetails = false;
        showRegisteredQr = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width / 2 - 32;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => bottomNavigationBar(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white, fontFamily: "gilroy"),
        ),
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => VehicleDataPage());
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (isEditMode) {
                  _updateUserData();
                }
                isEditMode = !isEditMode;
              });
            },
            icon: Icon(
              isEditMode ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Registered Mobile Number: $mobileNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'gilroy',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFB13D),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'gilroy',
                ),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'gilroy',
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                enabled: isEditMode,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'gilroy',
                ),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'gilroy',
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                enabled: isEditMode,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emergencyContactController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'gilroy',
                ),
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'gilroy',
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                enabled: isEditMode,
              ),
              const SizedBox(height: 25),
              const Text(
                'Registered QR Details',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'gilroy',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              isLoadingQrDetails
                  ? _buildShimmerEffect()
                  : showRegisteredQr
                      ? ElevatedButton(
                          onPressed: _showQRDetails,
                          child: Text(
                            'Show QR Details',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "gilroy",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFB13D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            minimumSize: Size(buttonWidth, 50),
                          ),
                        )
                      : const SizedBox(),
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.only(top: 220),
                child: TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "gilroy",
                    ),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size(50, 50),
                    backgroundColor: Color(0xFFFFB13D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _deleteAccount,
                child: const Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontFamily: "gilroy",
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size(buttonWidth, 50),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showQRDetails() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QRDetailsPage(registeredQrDetails: registeredQrDetails, mobileNumber: mobileNumber,),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Expanded(
      child: ListView.builder(
        itemCount: 5, // Assuming 5 shimmer items for simplicity
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 150,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 120,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 180,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 160,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 200,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateUserData() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String emergencyContact = _emergencyContactController.text;

    // Validate email format
    if (!isValidEmail(email)) {
      _showErrorDialog(context, 'Invalid Email Format');
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(mobileNumber)
        .collection('loginDetails')
        .doc(mobileNumber)
        .update({
      'name': name,
      'email': email,
      'emergencyContact': emergencyContact,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('User data updated successfully!'),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm Account Deletion',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore
                    .instance // after pressing delete user data get delete from the firebase auth
                    .collection('users')
                    .doc(mobileNumber)
                    .collection('loginDetails')
                    .doc(mobileNumber)
                    .delete();

                await user!.delete();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Account deleted successfully!'),
                  ),
                );
                Get.to(() => const LoginScreen());
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber);
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
