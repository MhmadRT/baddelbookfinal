import 'package:baddelbook/view/screen/main_screen.dart';
import 'package:baddelbook/view/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/lang/translation.dart';

var appLanguage = "en";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData(
        primaryColor: Color(0xff5DB6AE),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff0F1825),
        ),
        backgroundColor: Color(0xff0F1825),
        scaffoldBackgroundColor: Color(0xff0F1825),
        cardColor: Color(0xffF4C447),
        accentColor: Color(0xff243341),
        canvasColor: Color(0xff414852),
        textSelectionColor: Colors.white,
      ),
      theme: ThemeData(
        primaryColor: Color(0xff5DB6AE),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Color(0xff0F1825),),
          iconTheme: IconThemeData(color: Color(0xff0F1825),)
        ),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Color(0xffF4C447),
        accentColor: Colors.grey,
        canvasColor: Colors.grey.shade300,
        textSelectionColor: Color(0xff0F1825),
      ),
      themeMode: themeMode.value,
      translations: Translation(),
      locale: Locale(appLanguage),
      fallbackLocale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
ValueNotifier<ThemeMode>themeMode=ValueNotifier(ThemeMode.dark);
