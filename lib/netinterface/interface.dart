import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:http/http.dart' as http;
import 'package:rocketbot/models/refresh_token.dart';
import 'package:rocketbot/models/signin_code.dart';
import 'package:rocketbot/models/signin_key.dart';

import 'app_exception.dart';

class NetInterface {
  final String _baseUrl = "https://app.rocketbot.pro/api/mobile/";
  static const String token = "token";
  static const String tokenRefresh = "refreshToken";

  Future<dynamic> get(String url) async {
    String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
    var _token = await const FlutterSecureStorage().read(key: token);
    // print(_token);
// print(_baseUrl + url);
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "accept": "application/json",
        'User-Agent': _userAgent.toLowerCase(),
        "Authorization": " Bearer $_token",
      });
      responseJson = _returnResponse(response);
      // print(responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      debugPrint(e.toString());
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> request) async {
    String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
    var _token = await const FlutterSecureStorage().read(key: token);
    dynamic responseJson;
    var _query = json.encoder.convert(request);
    // print(_query);
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
            "Authorization": " Bearer $_token",
          },
          body: _query);
      responseJson = _returnResponse(response);
      // print(responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      debugPrint(e.toString());
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
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      Map _request = {"email": login, "password": pass};
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/Signin"),
          body: _query,
          headers: {
            'User-Agent': _userAgent.toLowerCase(),
            "accept": "application/json",
            "content-type" : "application/json"
          });
      print(response.body.toString());
      print(response.headers.toString());
      if (response.statusCode == 200) {
        var js = SignKey.fromJson(json.decode(response.body));
        return js.data!.key!;
      } else {
        // await const FlutterSecureStorage().delete(key: NetInterface.token);
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<bool> getEmailCode(String key) async {
    try {
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      Map _request = {"key": key};
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse(
              "https://app.rocketbot.pro/api/mobile/Auth/SendEmailCodeForSignin"),
          body: _query,
          headers: {
            'User-Agent': _userAgent.toLowerCase(),
            "accept": "application/json",
            "content-type" : "application/json"
          });
      // print(response.body);
      // print(response.headers.toString());
      if (response.statusCode == 200) {
        var js = SignKey.fromJson(json.decode(response.body));
        return true;
      } else {
        // await const FlutterSecureStorage().delete(key: NetInterface.token);
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<String?> getToken(String key, String code) async {
    try {
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      Map _request = {
        "key": key,
        "emailCode": code,
      };
      // print(jsonEncode(_request).toString());
      var _query = json.encoder.convert(_request);
      // print(_query);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/ConfirmSignin"),
          body: _query,
          headers: {
            "accept": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
            "content-type" : "application/json"
          });
      // print(response.body.toString());
      // print(response.statusCode);

      // response.headers.keys.forEach((element) {
      //  print(element.toString());
      // });

      if (response.statusCode == 200) {
        SignCode? res = SignCode.fromJson(json.decode(response.body));
        return res.data!.token!;
      } else {
        // await const FlutterSecureStorage().delete(key: NetInterface.token);
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<String?> getTokenGoogle(String tokenID) async {
    try {
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      Map _request = {
        "token": tokenID,
      };
      // print(jsonEncode(_request).toString());
      var _query = json.encoder.convert(_request);
      // print(_query);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/SignWithGoogle"),
          body: _query,
          headers: {
            "accept": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
            "content-type" : "application/json"
          });
      // print(response.body.toString());
      // print(response.statusCode);

      // response.headers.keys.forEach((element) {
      //  print(element.toString());
      // });

      if (response.statusCode == 200) {
        SignCode? res = SignCode.fromJson(json.decode(response.body));
        if (res.data!.token != null) {
          await const FlutterSecureStorage()
              .write(key: NetInterface.token, value: res.data!.token);
          await const FlutterSecureStorage().write(
              key: NetInterface.tokenRefresh, value: res.data!.refreshToken);
          return res.data!.token!;
        } else {
          return null;
        }
      } else {
        // await const FlutterSecureStorage().delete(key: NetInterface.token);
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
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
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
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
            'User-Agent': _userAgent.toLowerCase(),
            "accept": "application/json"
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
      debugPrint(e.toString());
      // print(e);
      return e.toString();
    }
  }

  static Future<int> forgotPass(String email) async {
    try {
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      Map _request = {
        "email": email,
      };
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/ForgotPassword"),
          body: _query,
          headers: {
            "accept": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
          });

      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  static Future<int> checkToken() async {
    try {
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      String? encoded =
          await const FlutterSecureStorage().read(key: NetInterface.token);
      final response = await http.get(
          Uri.parse(
              "https://app.rocketbot.pro/api/mobile/User/GetBalance?coinId=2"),
          headers: {
            'User-Agent': _userAgent.toLowerCase(),
            "Authorization": " Bearer $encoded",
          });
      // print(response.body);
      // print(response.statusCode);
      // debugPrint(_userAgent.toLowerCase());
      if (response.statusCode == 200) {
        return 0;
      } else {
        await const FlutterSecureStorage().delete(key: NetInterface.token);
        String? enc = await const FlutterSecureStorage()
            .read(key: NetInterface.tokenRefresh);
        Map _request = {
          "token": enc,
        };
        final resp = await http.post(
            Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/RefreshToken"),
            body: json.encode(_request),
            headers: {
              'User-Agent': _userAgent.toLowerCase(),
              "accept": "application/json",
              "content-type": "application/json",
            });
        // print(resp.body);
        // print(resp.statusCode);
        TokenRefresh? res = TokenRefresh.fromJson(json.decode(resp.body));
        if (res.data!.token != null) {
          await const FlutterSecureStorage()
              .write(key: NetInterface.token, value: res.data!.token);
          await const FlutterSecureStorage().write(
              key: NetInterface.tokenRefresh, value: res.data!.refreshToken);
          return 0;
        } else {
          return 1;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      return 1;
    }
  }
}
