import 'package:baddelbook/view/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

import '../../utils/helper/helper_widget.dart';
import '../../viewModel/login_viewmodel.dart';
import '../widget/countries_list.dart';
import '../widget/form_filedtext.dart';
import '../widget/logo.dart';
import '../widget/shake_widget.dart';
import '../widget/verify_phone.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: GetBuilder<LoginController>(
              init: LoginController(),
              builder: (controller) {
                controller.isRegister = false;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 160,
                      ),
                      const Logo(),
                      const SizedBox(
                        height: 40,
                      ),
                      Text('loginToGetStarted'.tr,
                          style: TextStyle(
                              color: Theme.of(context).textSelectionColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 23)),
                      const SizedBox(
                        height: 5,
                      ),
                      // Text('youWillReceiveA5DigitsCodeForPhoneNumberVerification'.tr,
                      //     style: TextStyle(
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 16)),
                      const SizedBox(
                        height: 58,
                      ),
                      Form(
                        key: controller.formPhoneKey,
                        child: ShakeWidget(
                          key: controller.phoneShake,
                          shakeOffset: 10,
                          shakeCount: 3,
                          shakeDuration: const Duration(milliseconds: 300),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HelperWidgets.showSheet(
                                      child: const CountriesList(),
                                      title: 'selectCountryCode'.tr);
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          Theme.of(context).textSelectionColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                          size: 30,
                                        ),
                                        Text(
                                          controller.countryCode?.dialCode ??
                                              '',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textSelectionColor,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: FormFieldText(
                                  hints: "phoneNumber".tr,
                                  onChanged: (v) {
                                    controller.phone = v;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      controller.phoneShake.currentState
                                          ?.shake();
                                      return 'pleaseEnterPhone'.tr;
                                    } else if (!GetUtils.isPhoneNumber(value)) {
                                      controller.phoneShake.currentState
                                          ?.shake();
                                      return 'Invalid phone number !';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      if (controller.verificationPhoneVisible)
                        const VerityNumber(),
                      if (!controller.verificationPhoneVisible)
                        GestureDetector(
                          onTap: () {
                            if (controller.formPhoneKey.currentState!
                                .validate()) {
                              controller.authByPhoneNumber();
                            }
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Get.theme.primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                "Login".tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (!controller.verificationPhoneVisible)
                        InkWell(
                          onTap: () {
                            Get.to(RegisterScreen());
                          },
                          child: Wrap(
                            children: [
                              Text(
                                'dontHaveAnAccount'.tr + ',',
                                style: TextStyle(
                                  color: Theme.of(context).textSelectionColor,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'createAnAccount'.tr,
                                style: TextStyle(
                                    color: Theme.of(context).cardColor),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
