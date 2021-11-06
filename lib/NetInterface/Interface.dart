import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'AppException.dart';

class NetInterface {
  final String _baseUrl = "https://app.rocketbot.pro/api/mobile/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        "accept": "application/json",
        "Authorization":" Basic bTFjaGxAY2VudHJ1bS5jejpBMTIzNDU2YQ==",
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
}
