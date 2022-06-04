import 'dart:developer';

import 'package:baddelbook/model/user.dart';
import 'package:baddelbook/view/screen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helper/helper_widget.dart';
import '../view/widget/countries_list.dart';
import '../view/widget/shake_widget.dart';

Rx<String?> uid = Rx(null);

class LoginController extends GetxController {
  final GlobalKey<FormState> formPhoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formCodeKey = GlobalKey<FormState>();
  final phoneShake = GlobalKey<ShakeWidgetState>();

  Country? countryCode =
      Country(name: 'Jordan', code: '+962', dialCode: "+962");
  String verificationCode = '';
  String? phone;
  bool? isLoading;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int? resendToken;
  String? verificationId;
  String deviceToken = 'ksafdmfklasdmff';
  bool isRegister = false;
  bool verificationPhoneVisible = false;
  UserModel userModel = UserModel();

  @override
  void onInit() async {
    super.onInit();
  }

  confirmCodeWithPhoneNumber() async {
    try {
      HelperWidgets.loading();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId ?? "22", smsCode: verificationCode);
      await _auth.signInWithCredential(credential).then((value) async {
        ///API REQUEST
        if (isRegister) {
         await FirebaseFirestore.instance
              .collection('Users')
              .doc(value.user!.uid)
              .set(userModel.toJson());
        }else{
         var q= await FirebaseFirestore.instance
              .collection('Users')
              .doc(value.user!.uid).get();
          UserModel userModel=UserModel.fromJson(q.data()??{});
          if(userModel.fullName==null)
            throw 'register';
        }
        await saveUid(value.user?.uid ?? '');
        verificationPhoneVisible = false;
        update();
      }).catchError((e) {
        verificationPhoneVisible = false;
        update();
        log(e.toString());
        Get.back();
        if(e=='register') {
          HelperWidgets.errorBar(
              title: "You don't have an account.",
              message: 'Please create new account',
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ));
        }else{
          HelperWidgets.errorBar(
              title: 'Invalid code',
              message: 'The code you entered is incorrect',
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ));
        }
      });
    } catch (e) {
      log(e.toString());
      Get.back();
      HelperWidgets.errorBar(
          title: 'Login error',
          message: 'This account does not exist',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
    }
  }

  authByPhoneNumber() async {
    HelperWidgets.loading();
    await _auth.verifyPhoneNumber(
        phoneNumber: '${countryCode!.dialCode}$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            print(1234567890);
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          verificationPhoneVisible = false;
          update();
          log("ERROR:${e.toString()}");
          Get.back(); //STOP LOADING
          if (e.code == 'invalid-phone-number') {
            HelperWidgets.errorBar(
                title: 'Login Error',
                message: 'The provided phone number is not valid.',
                icon: const Icon(
                  Icons.error,
                  color: Color(0xf4ad0000),
                ));
          } else {
            print("ERROR:${e.toString()}");
            HelperWidgets.errorBar(
                title: 'Login Error',
                message: 'Check your network or phone number',
                icon: const Icon(
                  Icons.error,
                  color: Color(0xf4ad0000),
                ));
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          print('${countryCode!.dialCode}$phone');
          this.verificationId = verificationId;
          this.resendToken = resendToken;
          Get.back(); //STOP LOADING
          verificationPhoneVisible = true;
          update();
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          verificationPhoneVisible = false;
          // update();
          // Get.back(); //STOP LOADING
          // Get.snackbar('Verify error',
          //     'You have one minute to verify your phone number, and one try\nPlease Try again',
          //     icon: const Icon(
          //       Icons.timer_off,
          //       color: Colors.amber,
          //     ));
        },
     );
  }

  saveUid(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('uid', id);
    uid.value = id;
    Get.offAll(SplashScreen());
  }logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('uid');
    uid.value = null;
    Get.offAll(SplashScreen());
  }
}
