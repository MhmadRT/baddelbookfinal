import 'package:baddelbook/view/screen/home_screen.dart';
import 'package:baddelbook/view/screen/main_screen.dart';
import 'package:baddelbook/viewModel/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/helper/helper_widget.dart';
import '../widget/countries_list.dart';
import '../widget/custom_textfiled.dart';
import '../widget/form_filedtext.dart';
import '../widget/shake_widget.dart';
import '../widget/verify_phone.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String studentID = '';
  String specialization = '';
  String phone = '';
  bool hasValidMime = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: GetBuilder<LoginController>(
                  init: LoginController(),
                  builder: (con) {
                    con.isRegister = true;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          // ignore: prefer_const_constructors
                          icon: Icon(Icons.arrow_back_ios_rounded),
                          iconSize: 18,
                          color: Theme.of(context).textSelectionColor,
                        ),
                        Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'createAnAccount'.tr,
                              style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Gotham',
                              ),
                            ),
                            SvgPicture.asset(
                              'images/logoBook.svg',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        CustomTextFiled(
                          text: 'fullName'.tr,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'PleaseEnterName'.tr;
                            }
                            hasValidMime = true;
                            return null;
                          },
                          onChanged: (v) {
                            con.userModel.fullName = v;
                          },
                          hint: '',
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomTextFiled(
                          text: 'studentId'.tr,
                          hint: '',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'PleaseEnterStudentid'.tr;
                            }
                            hasValidMime = true;
                            return null;
                          },
                          onChanged: (v) {
                            con.userModel.studentId = v;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        CustomTextFiled(
                          text: 'specialization'.tr,
                          hint: '',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseEnterSpecialization'.tr;
                            }
                            hasValidMime = true;
                            return null;
                          },
                          onChanged: (v) {
                            con.userModel.specialization = v;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'phone'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textSelectionColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
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
                                  border: Border.all(color: Theme.of(context).textSelectionColor),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Theme.of(context).textSelectionColor,
                                        size: 30,
                                      ),
                                      Text(
                                        con.countryCode?.dialCode ?? '',
                                        style: TextStyle(
                                            color: Theme.of(context).textSelectionColor.withOpacity(0.5),
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
                                  con.userModel.phoneNumber = v;
                                  con.phone = v;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    // con.phoneShake.currentState?.shake();
                                    return 'pleaseEnterPhone'.tr;
                                  } else if (!GetUtils.isPhoneNumber(value)) {
                                    // con.phoneShake.currentState?.shake();
                                    return 'invalid'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        if (con.verificationPhoneVisible) const VerityNumber(),
                        if (!con.verificationPhoneVisible)
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                con.authByPhoneNumber();
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
                                  "createAnAccount".tr,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).textSelectionColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
