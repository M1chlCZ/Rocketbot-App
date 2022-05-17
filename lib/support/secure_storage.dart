import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {


  static Future<String?> readStorage({required String key}) {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      const optionsApple = IOSOptions(accessibility: IOSAccessibility.first_unlock);
      const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
      return  storage.read(key: key, iOptions: optionsApple, aOptions: optionsAndroid);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.value(null);
    }
  }

  static Future<void> writeStorage({required String key,required String value}) {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      const optionsApple = IOSOptions(accessibility: IOSAccessibility.first_unlock);
      const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
      return  storage.write(key: key, value: value, iOptions: optionsApple, aOptions: optionsAndroid);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.value(null);
    }

  }

  static Future<void> deleteStorage({required String key}) {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      const optionsApple = IOSOptions(accessibility: IOSAccessibility.first_unlock);
      const optionsAndroid = AndroidOptions(encryptedSharedPreferences: true);
      return   storage.delete(key: key, iOptions: optionsApple, aOptions: optionsAndroid);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.value(null);
    }
  }

}