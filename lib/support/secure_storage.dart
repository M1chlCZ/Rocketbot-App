import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {


  static Future<String?> readStorage({required String key}) {
    try {
      const FlutterSecureStorage _storage = FlutterSecureStorage();
      const optionsApple = IOSOptions(accessibility: IOSAccessibility.first_unlock);
      const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
      return  _storage.read(key: key, iOptions: optionsApple, aOptions: optionsAndroid);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  static Future<void> writeStorage({required String key,required String value}) {
    try {
      const FlutterSecureStorage _storage = FlutterSecureStorage();
      const optionsApple = IOSOptions(accessibility: IOSAccessibility.first_unlock);
      const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
      return  _storage.write(key: key, value: value, iOptions: optionsApple, aOptions: optionsAndroid);
    } catch (e) {
      print(e);
      return Future.value(null);
    }

  }

  static Future<void> deleteStorage({required String key}) {
    try {
      const FlutterSecureStorage _storage = FlutterSecureStorage();
      const optionsApple = IOSOptions(accessibility: IOSAccessibility.first_unlock);
      const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
      return   _storage.delete(key: key, iOptions: optionsApple, aOptions: optionsAndroid);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

}