import 'dart:async';

import 'package:baddelbook/view/screen/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../viewModel/login_viewmodel.dart';
import 'otp_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getUid();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                uid.value == null || uid.value == ''
                    ? OTPScreen()
                    : MainScreen())));
  }

  getUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid.value = preferences.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/logo2.svg',
              height: 150,
              width: 150,
            ),
            CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
