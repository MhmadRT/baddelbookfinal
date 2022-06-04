import 'package:baddelbook/view/screen/inbox_screen.dart';
import 'package:baddelbook/view/screen/profile_screen.dart';
import 'package:baddelbook/view/screen/request_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController controller = PageController();
  int currentIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const InboxScreen(),
    const RequestScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: Get.height,
              width: Get.width,
              child: screens[currentIndex]),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 80,
              width: 425,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 0;
                              });
                            },
                            child: SvgPicture.asset(
                              'images/homeIcon.svg',
                              color: currentIndex == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 1;
                              });
                            },
                            child: SvgPicture.asset('images/notfcationIcon.svg',
                                color: currentIndex != 1
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 2;
                              });
                            },
                            child: SvgPicture.asset('images/inboxIcon.svg',
                                color: currentIndex != 2
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentIndex = 3;
                              });
                            },
                            child: SvgPicture.asset('images/profileIcon.svg',
                                color: currentIndex != 3
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
