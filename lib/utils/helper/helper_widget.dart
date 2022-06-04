import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class HelperWidgets {
  static showSheet(
      {required Widget child, required String title, bool? canClose}) {
    showMaterialModalBottomSheet(
        context: Get.context!,
        isDismissible: false,
        barrierColor: Colors.black87,
        duration: const Duration(milliseconds: 300),
        builder: (context) => SizedBox(
            height: Get.height / 1.1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style:  TextStyle(fontWeight: FontWeight.bold,color: Get.theme.textSelectionColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Get.theme.dividerColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(Icons.clear,
                                color: Get.theme.accentColor, size: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                Expanded(child: child),
              ],
            )),
        backgroundColor: Get.theme.accentColor,
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))));
  }

  static loading() {
    Get.closeCurrentSnackbar();
    if (Platform.isIOS) {
      Get.dialog(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CupertinoActivityIndicator(),
            ],
          ),
          barrierColor: Get.theme.scaffoldBackgroundColor.withOpacity(0.6),
          barrierDismissible: false);
    } else {
      Get.dialog(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
          barrierColor: Get.theme.scaffoldBackgroundColor.withOpacity(0.6),
          barrierDismissible: false);
    }
  }

  static errorBar({String? title, String? message, Icon? icon,}) {
    HapticFeedback.vibrate();
    Get.snackbar(title ?? "", message ?? "",
        icon: icon, duration: const Duration(seconds: 3));
  }





}
