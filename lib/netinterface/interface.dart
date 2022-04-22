import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:http/http.dart' as http;
import 'package:rocketbot/models/pos_token_auth.dart';
import 'package:rocketbot/models/refresh_token.dart';
import 'package:rocketbot/models/signin_code.dart';
import 'package:rocketbot/models/signin_key.dart';

import 'app_exception.dart';

class NetInterface {
  final String _baseUrl = "https://app.rocketbot.pro/api/mobile/";
  final String _posUrl = "http://51.195.168.17:7465/";
  static const String token = "token";
  static const String posToken = "posToken";
  static const String tokenRefresh = "refreshToken";
  static const String posTokenRefresh = "posRefreshToken";
  static bool _refreshingToken = false;

  Future<dynamic> get(String url, {bool pos = false}) async {
    String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
    var _token =
        await const FlutterSecureStorage().read(key: pos ? posToken : token);
    // print(_token);
// // print(_baseUrl + url);
    dynamic responseJson;
    try {
      var _curl = "";
      pos ? _curl = _posUrl + url : _curl = _baseUrl + url;
      // print(_curl);
      // print(_token);
      final response = await http.get(Uri.parse(_curl), headers: {
        'User-Agent': _userAgent.toLowerCase(),
        "Authorization": " Bearer $_token",
      });

      // print(response.statusCode);
      // print(response.body.toString());
      if (response.statusCode == 403 || response.statusCode == 401) {
        await refreshToken(pos: pos);
        var _token = await const FlutterSecureStorage()
            .read(key: pos ? posToken : token);
        final res = await http.get(Uri.parse(_curl), headers: {
          'User-Agent': _userAgent.toLowerCase(),
          "Authorization": " Bearer $_token",
        });
        responseJson = await compute (_returnResponse,res);
      } else {
        responseJson = await compute (_returnResponse,response);
      }
      // print(responseJson.toString());
    } on SocketException {
      // print("shit");
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> request,
      {bool pos = false}) async {
    String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
    var _token =
        await const FlutterSecureStorage().read(key: pos ? posToken : token);
    dynamic responseJson;
    var _query = json.encoder.convert(request);
    // print(_query);
    try {
      var _curl = "";
      pos ? _curl = _posUrl + url : _curl = _baseUrl + url;
      // print(_curl);
      final response = await http.post(Uri.parse(_curl),
          headers: {
            "content-type": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
            "Authorization": " Bearer $_token",
          },
          body: _query);
      // print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 403 || response.statusCode == 401) {
        await refreshToken(pos: pos);
        var _token = await const FlutterSecureStorage()
            .read(key: pos ? posToken : token);
        final res = await http.post(Uri.parse(_curl),
            headers: {
              "content-type": "application/json",
              'User-Agent': _userAgent.toLowerCase(),
              "Authorization": " Bearer $_token",
            },
            body: _query);
        responseJson = await compute (_returnResponse,res);
      } else {
        responseJson = await compute (_returnResponse,response);
      }
      // print(responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  static dynamic _returnResponse(http.Response response) async {
    // // print(response.statusCode);
    // print(response.body.toString());
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
          throw UnauthorisedException(response.body.toString());
      case 403:
        await checkToken();
        break;
      // throw UnauthorisedException(response.body.toString());
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
            "content-type": "application/json"
          });

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
            "content-type": "application/json"
          });

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
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/ConfirmSignin"),
          body: _query,
          headers: {
            "accept": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
            "content-type": "application/json"
          });

      if (response.statusCode == 200) {
        SignCode? res = SignCode.fromJson(json.decode(response.body));
        await const FlutterSecureStorage()
            .write(key: NetInterface.token, value: res.data!.token);
        await const FlutterSecureStorage().write(
            key: NetInterface.tokenRefresh, value: res.data!.refreshToken);
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
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/SignWithGoogle"),
          body: _query,
          headers: {
            "accept": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
            "content-type": "application/json"
          });
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

  static Future<String?> getTokenApple(String authorizationCode) async {
    try {
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      Map _request = {
        "authorizationCode": authorizationCode,
      };
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/SignWithApple"),
          body: _query,
          headers: {
            "accept": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
            "content-type": "application/json"
          });
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

  static Future<String?> registerUser(
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
      // // print(_query);
      final response = await http.post(
          Uri.parse("https://app.rocketbot.pro/api/mobile/Auth/Signup"),
          body: _query,
          headers: {
            'User-Agent': _userAgent.toLowerCase(),
            "accept": "application/json",
            "content-type": "application/json"
          });

      // print(response.body);
      // print(response.headers);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        SignCode? res = SignCode.fromJson(json.decode(response.body));
        if (res.data!.token != null) {
          await const FlutterSecureStorage()
              .write(key: NetInterface.token, value: res.data!.token);
          await const FlutterSecureStorage().write(
              key: NetInterface.tokenRefresh, value: res.data!.refreshToken);
        }
      }
      return response.body;
    } catch (e) {
      debugPrint(e.toString());
      // // print(e);
      return null;
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
      // print("check token////");
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
      // // print(response.body);
      // // print(response.statusCode);
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
        // // print(resp.body);
        // // print(resp.statusCode);
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

  static Future<void> refreshToken({bool pos = false}) async {

    try {
      if (_refreshingToken) {
        return;
      }
      _refreshingToken = true;

      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      await const FlutterSecureStorage()
          .delete(key: pos ? NetInterface.posToken : NetInterface.token);
      String? enc = await const FlutterSecureStorage().read(
          key: pos ? NetInterface.posTokenRefresh : NetInterface.tokenRefresh);
      Map _request = {
        "token": enc,
      };
      final resp = await http.post(
          pos
              ? Uri.parse("http://51.195.168.17:7465/auth/refreshToken")
              : Uri.parse(
                  "https://app.rocketbot.pro/api/mobile/Auth/RefreshToken"),
          body: json.encode(_request),
          headers: {
            'User-Agent': _userAgent.toLowerCase(),
            "accept": "application/json",
            "content-type": "application/json",
          });

      TokenRefresh? res = TokenRefresh.fromJson(json.decode(resp.body));
      if (res.data!.token != null) {
        if (pos) {
          await const FlutterSecureStorage()
              .write(key: NetInterface.posToken, value: res.data!.token);
          await const FlutterSecureStorage().write(
              key: NetInterface.posTokenRefresh, value: res.data!.refreshToken);
        } else {
          await const FlutterSecureStorage()
              .write(key: NetInterface.token, value: res.data!.token);
          await const FlutterSecureStorage().write(
              key: NetInterface.tokenRefresh, value: res.data!.refreshToken);
        }
        _refreshingToken = false;
      }
      _refreshingToken = false;
    } catch (e) {
      if (pos) {
        await const FlutterSecureStorage()
            .delete(key: NetInterface.posToken);
        await const FlutterSecureStorage().delete(
            key: NetInterface.posTokenRefresh);
      }
      _refreshingToken = false;
      debugPrint(e.toString());
    }
  }

  static Future<void> registerPos(String token) async {
    try {
      String _userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      Map _request = {
        "token": token,
      };
      var _query = json.encoder.convert(_request);
      final response = await http.post(
          Uri.parse("http://51.195.168.17:7465/auth"),
          body: _query,
          headers: {
            "Content-Type": "application/json",
            "accept": "application/json",
            'User-Agent': _userAgent.toLowerCase(),
          });
      if (response.statusCode == 200) {
        PosTokenAuth? res = PosTokenAuth.fromJson(json.decode(response.body));
        await const FlutterSecureStorage()
            .write(key: NetInterface.posToken, value: res.token);
        await const FlutterSecureStorage()
            .write(key: NetInterface.posTokenRefresh, value: res.refreshToken);
      } else {
        print(response.body);
        debugPrint("Fuck");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
