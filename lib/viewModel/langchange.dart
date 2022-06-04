import 'dart:ui';

import 'package:get/get.dart';

import '../utils/local_storge/local_storge.dart';

class ControllerAnimated extends GetxController{
  int selectedIndex=0;
  String ?appLanguage = "en";

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    LocalStorage localStorage = LocalStorage();
    appLanguage = await localStorage.languageSelected;
    Get.updateLocale(Locale(appLanguage??'en'));
    update();
  }

  void changeLanguage(String language) {
    LocalStorage localStorage = LocalStorage();
    if (language == appLanguage) return;
    if (language == 'ar') {
      appLanguage = 'ar';
      localStorage.saveLanguageToDisk('ar');
    } else {
      appLanguage = 'en';
      localStorage.saveLanguageToDisk('en');
    }
    Get.updateLocale(Locale(appLanguage??'en'));
    update();
  }
}