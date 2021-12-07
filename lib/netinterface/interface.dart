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
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "accept": "application/json",
        "Authorization":" Basic $_token",
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
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

  static Future<int> createToken(String login, String pass) async  {
    var credentials = login + ":" + pass;
    String encoded = base64.encode(utf8.encode(credentials));
    final response = await http.get(Uri.parse("https://app.rocketbot.pro/api/mobile/User/GetBalance?coinId=2"), headers: {
      "accept": "application/json",
      "Authorization":" Basic $encoded",
    });
    if(response.statusCode == 200) {
      await const FlutterSecureStorage().write(key: NetInterface.token , value: encoded);
      return 0;
    }else {
      await const FlutterSecureStorage().delete(key: NetInterface.token);
      return 1;
    }
  }

  static Future<int> checkToken () async {
    String? encoded = await const FlutterSecureStorage().read(key: NetInterface.token);
    final response = await http.get(Uri.parse("https://app.rocketbot.pro/api/mobile/User/GetBalance?coinId=2"), headers: {
      "accept": "application/json",
      "Authorization":" Basic $encoded",
    });
    if(response.statusCode == 200) {
      return 0;
    }else {
      await const FlutterSecureStorage().delete(key: NetInterface.token);
      return 1;
    }
  }
}
