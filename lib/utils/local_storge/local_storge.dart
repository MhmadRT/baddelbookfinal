import 'package:get_storage/get_storage.dart';

class LocalStorage {
  ///Write on Disk
  void saveLanguageToDisk(String language) async {
    await GetStorage().write('lang', language);
  }

  Future<bool> checkLanguage() async {
    return GetStorage().hasData('lang');
  }

  ///Read from Disk
  Future<dynamic> get languageSelected async {
    return await GetStorage().read('lang');
  }
}
