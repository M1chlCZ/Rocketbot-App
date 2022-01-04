
import 'package:rocketbot/models/coin.dart';

class DepositAddress {
  DepositAddress({
      String? message, 
      bool? hasError, 
      dynamic error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  DepositAddress.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  dynamic _error;
  Data? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  dynamic get error => _error;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      Coin? coin, 
      String? address,}){
    _coin = coin;
    _address = address;
}

  Data.fromJson(dynamic json) {
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _address = json['address'];
  }
  Coin? _coin;
  String? _address;

  Coin? get coin => _coin;
  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    map['address'] = _address;
    return map;
  }

}
