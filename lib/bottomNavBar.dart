import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:safe_connect/BottomNavBar%20Features/SOSPopup.dart';
import 'package:safe_connect/BottomNavBar%20Features/help.dart';
import 'package:safe_connect/BottomNavBar%20Features/helplinePopUp.dart';
import 'package:safe_connect/BottomNavBar%20Features/soundRecorder.dart';
import 'package:safe_connect/screens/HelpLogScreen/helpLogScreen.dart';
import 'package:safe_connect/screens/HomeScreen/homeScreen.dart';
import 'package:safe_connect/screens/QrScanner/qrScan.dart';
import 'package:safe_connect/screens/QrScanner/qrScanner.dart';

class bottomNavigationBar extends StatefulWidget {
  @override
  _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  int _selectedIndex = 0; // Set the initial index to 0 for HomeScreen

  List<Color> _iconColors = [
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    // const HelpLineScreen(),
    HelpPopup(),
    HelpRecords(),
    SOSPopup(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _updateIconColors(index);
    });
  }

  void _updateIconColors(int selectedIndex) {
    for (int i = 0; i < _iconColors.length; i++) {
      _iconColors[i] = i == selectedIndex ? Colors.white : Colors.grey;
    }
  }

  Widget _buildIconWithDot(IconData iconData, int index) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(iconData, color: _iconColors[index]),
          onPressed: () => _onItemTapped(index),
        ),
        if (_selectedIndex == index)
          Positioned(
            bottom: 0,
            left: 21.5, // Adjust this value to position the dot as desired
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Show selected screen
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Get.to(() => const QRCodeScanner());
          Get.to(() => const QRScanner());
        },
        child: const Icon(
          Icons.qr_code,
          color: Colors.black,
          size: 35,
        ),
        backgroundColor: Color(0xffAAAFB5),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 70, // Reduce the height of the bottom navigation bar
        child: BottomAppBar(
          color: Color(0xff1A1919),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildIconWithDot(Icons.home, 0),
              _buildIconWithDot(Icons.handshake, 1),
              _buildIconWithDot(Icons.chat, 2),
              _buildIconWithDot(Icons.safety_check, 3),
            ],
          ),
        ),
      ),
    );
  }
}
