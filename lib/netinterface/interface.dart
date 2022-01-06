import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'app_exception.dart';

class NetInterface {
  final String _baseUrl = "https://app.rocketbot.pro/api/mobile/";
  static const String token = "token";

  Future<dynamic> get(String url) async {
    var _token = await const FlutterSecureStorage().read(key: token);
    // print(_token);
// print(_baseUrl + url);
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "accept": "application/json",
        "Authorization": " Bearer $_token",
      });
      responseJson = _returnResponse(response);
      // print(responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> request) async {
    var _token = await const FlutterSecureStorage().read(key: token);
    dynamic responseJson;
    var _query = json.encoder.convert(request);
    // print(_query);
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": " Bearer $_token",
          },
          body: _query);
      responseJson = _returnResponse(response);
      // print(responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    // print(response.statusCode);
    // print(response.toString());
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  static Future<String?> getKey(String login, String pass) async {
    try {
      Map _request = {"email": login, "password": pass};
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/Signin"),
          body: _query,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
          });
      // print(response.body);
      // print(response.headers.toString());
      if (response.statusCode == 200) {
        var js = json.decode(response.body);
        return js['data'];
      } else {
        // await const FlutterSecureStorage().delete(key: NetInterface.token);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getToken(String key, String code) async {
    try {
      Map _request = {"key": key, "code": code};
      var _query = json.encoder.convert(_request);
      // print(_query);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/SignInCode"),
          body: _query,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
          });
      // print(response.body);
      // response.headers.keys.forEach((element) {
      //  print(element.toString());
      // });

      if (response.statusCode == 200) {
        String? token;
        for (var element in response.headers.entries) {
          if (element.key == 'token') {
            token = element.value;
            break;
          }
        }
        return token;
      } else {
        // await const FlutterSecureStorage().delete(key: NetInterface.token);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String> registerUser(
      {required String email,
      required String pass,
      required String passConf,
      required String name,
      required String surname,
      required bool agreed}) async {
    try {
      Map _request = {
        "email": email,
        "password": pass,
        "confirmPassword": passConf,
        "name": name,
        "surname": surname,
        "agreeToConditions": agreed
      };
      var _query = json.encoder.convert(_request);
      // print(_query);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/Signup"),
          body: _query,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
          });

      // print(response.body);
      if (response.statusCode == 200) {
        String? token;
        for (var element in response.headers.entries) {
          if (element.key == 'token') {
            token = element.value;
            // print(token);
          }
        }

        await const FlutterSecureStorage()
            .write(key: NetInterface.token, value: token);
      }

      return response.body;
    } catch (e) {
      // print(e);
      return e.toString();
    }
  }

  static Future<int> forgotPass(String email) async {
    try {
      Map _request = {
        "email": email,
      };
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/ForgotPassword"),
          body: _query,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
          });

      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> checkToken() async {
    String? encoded =
        await const FlutterSecureStorage().read(key: NetInterface.token);
    final response = await http.get(
        Uri.parse(
            "https://app.rocketbot.pro/api/mobile/User/GetBalance?coinId=2"),
        headers: {
          "accept": "application/json",
          "Authorization": " Bearer $encoded",
        });
    // print(response.body);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      return 0;
    } else {
      await const FlutterSecureStorage().delete(key: NetInterface.token);
      return 1;
    }
  }
}
