import 'dart:convert';

import 'package:baddelbook/utils/helper/helper_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user.dart';
import '../../viewModel/login_viewmodel.dart';
import 'form_filedtext.dart';
import 'loading_widget.dart';

class UpdateDataSheet extends StatefulWidget {
  const UpdateDataSheet({Key? key}) : super(key: key);

  @override
  _UpdateDataSheetState createState() => _UpdateDataSheetState();
}

class _UpdateDataSheetState extends State<UpdateDataSheet> {
  final GlobalKey<FormState> formPhoneKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(uid.value ?? '')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: LoadingWidget());
            var userData = snapshot.data;
            UserModel user =
                UserModel.fromJson(json.decode(json.encode(userData.data())));
            String name = user.fullName ?? "";
            String spec = user.specialization ?? '';
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formPhoneKey,
                child: Column(
                  children: [
                    FormFieldText(
                      initialValue: user.fullName ?? "",
                      label: 'fullName'.tr,
                      validator: (v) {
                        return v?.isEmpty ?? true ? 'invalid'.tr : null;
                      },
                      onChanged: (v) {
                        name = v;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormFieldText(
                      label: 'specialization'.tr,
                      validator: (v) {
                        print(v);
                        return v?.isEmpty ?? true ? 'invalid'.tr : null;
                      },
                      onChanged: (v) {
                        spec = v;
                      },
                      initialValue: user.specialization ?? "",
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () async {
                        print('update');
                        if (formPhoneKey.currentState?.validate() ?? false) {
                          HelperWidgets.loading();
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(uid.value)
                              .update({
                            'full_name': name,
                            'specialization': spec,
                          }).then((value) {
                            print(uid.value);
                          });
                          Get.back();
                          Get.back();
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
                            "save".tr,
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
                  ],
                ),
              ),
            );
          }),
    );
  }
}
