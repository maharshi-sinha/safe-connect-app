import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:safe_connect/screens/LogsScreen/logsScreen.dart';
import 'package:safe_connect/screens/QrInfoScreen/carinfo.dart';
import 'package:safe_connect/screens/QrInfoScreen/childinfo.dart';
import 'package:safe_connect/screens/QrInfoScreen/keyinfo.dart';
import 'package:safe_connect/screens/QrInfoScreen/petinfo.dart';
import 'package:safe_connect/screens/QrInfoScreen/qrwallpaperinfo.dart';
import 'package:safe_connect/screens/QrRegistrationScreen/ChildRegistration.dart';
import 'package:safe_connect/screens/QrRegistrationScreen/PetRegistration.dart';
import 'package:safe_connect/screens/QrRegistrationScreen/qrWallpaper.dart';

class newSecondChild extends StatelessWidget {
  const newSecondChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: "gilroy", fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Our', style: TextStyle(color: Color(0xffFFFFFf))),
                  TextSpan(text: ' '),
                  TextSpan(
                      text: 'Services',
                      style: TextStyle(color: Color(0xffFFB13D))),
                ],
              ),
            )
          ],
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 124,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.to(() => carQr());
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/vehicle.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Vehicle',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xffFFB13D),
                              fontFamily: 'gilroy',
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => childinfo());
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/child.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Child',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xffFFB13D),
                            fontFamily: 'gilroy',
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => petinfo());
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/pet.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Pet',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xffFFB13D),
                            fontFamily: 'gilroy',
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => qrwallpaperinfo());
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/icons/electronics.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Electronics',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xffFFB13D),
                              fontFamily: 'gilroy',
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 124,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.to(() => LogScreen());
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/bag.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Bag',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xffFFB13D),
                              fontFamily: 'gilroy',
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Get.to(() => keyQR());
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icons/key.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Key',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xffFFB13D),
                            fontFamily: 'gilroy',
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/doorbell.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Door Bell',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xffFFB13D),
                            fontFamily: 'gilroy',
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/icons/more.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'More',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xffFFB13D),
                            fontFamily: 'gilroy',
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
