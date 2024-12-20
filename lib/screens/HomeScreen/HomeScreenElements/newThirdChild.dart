import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:safe_connect/screens/QrInfoScreen/carinfo.dart';
import 'package:safe_connect/screens/Story/storyFeed.dart';
import 'package:safe_connect/screens/Story/uploadStory.dart';

class newThirdChild extends StatelessWidget {
  const newThirdChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Services & Features",
              style: TextStyle(
                  fontFamily: "gilroy", fontSize: 18, color: Colors.white),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Get.to(() => const carQr());
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/internet.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () => Get.to(() => StoryUploadPage()),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/tvn.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () => Get.to(() => StoryFeedPage()),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/water.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/invest.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Internet',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'gilroy',
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'TV Cable',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'gilroy',
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Water',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'gilroy',
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Investment',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
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
                height: 10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
