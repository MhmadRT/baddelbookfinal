import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../viewModel/login_viewmodel.dart';

class VerityNumber extends StatefulWidget {
  const VerityNumber({Key? key}) : super(key: key);

  @override
  State<VerityNumber> createState() => _VerityNumberState();
}

class _VerityNumberState extends State<VerityNumber>
    with SingleTickerProviderStateMixin {
  AnimationController? _controllerTime;
  bool isResend = false;
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _controllerTime =
        AnimationController(vsync: this, duration: const Duration(minutes: 1));
    _controllerTime!.forward().whenComplete(() {
      if (mounted) {
        setState(() {
          isResend = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _controllerTime!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Get.theme.textSelectionColor)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: PinCodeTextField(
                        appContext: context,
                        cursorHeight: 20,
                        pastedTextStyle: TextStyle(
                          color: Get.theme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Get.theme.textSelectionColor),
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v!.length < 3) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          selectedColor: Colors.grey,
                          selectedFillColor: Get.theme.dividerColor,
                          activeColor: Get.theme.primaryColor,
                          disabledColor: Get.theme.textSelectionColor,
                          inactiveColor: Get.theme.textSelectionColor,
                          inactiveFillColor:
                              Get.theme.accentColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 30,
                          fieldWidth: 30,
                          borderWidth: 1,
                          activeFillColor: Get.theme.dividerColor,
                        ),
                        cursorColor: Get.theme.textSelectionColor,
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        keyboardType: TextInputType.number,
                        errorTextSpace: 0,
                        onCompleted: (v) async {
                          try {
                            controller.confirmCodeWithPhoneNumber();
                          } catch (e) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        onChanged: (value) {
                          controller.verificationCode = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Didn't receive the code? ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.textSelectionColor.withOpacity(0.5))),
                !isResend
                    ? Countdown(
                        animation: StepTween(
                          begin: 60,
                          // THIS IS A USER ENTERED NUMBER
                          end: 0,
                        ).animate(_controllerTime!),
                      )
                    : Text("Resend code ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.primaryColor)),
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}

ValueNotifier<Duration> sleepWhen = ValueNotifier(Duration.zero);

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;
  bool isTimeout = false;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    sleepWhen.value = clockTimer;

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    if (timerText == '0') {
      timerText = '0';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Sent after $timerText sec",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Get.theme.primaryColor)),
    );
  }
}
