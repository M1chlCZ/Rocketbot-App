import 'package:rocketbot/models/coin.dart';

/// message : "Successfully executed."
/// hasError : false
/// error : null
/// data : {"userId":68857,"coin":{"id":2,"rank":1,"name":"Merge","ticker":"MERGE","coinGeckoId":"merge","cryptoId":"MERGE","isToken":false,"blockchain":0,"minWithdraw":1,"imageBig":"9149137e7940687397146d176b2a62d9.png","imageSmall":"29cd07ad2090ac1be8890f9258bf60d7.png","isActive":true,"explorerUrl":"https://explorer.projectmerge.org/tx/{0}","requiredConfirmations":20,"feePercent":0,"fullName":"Merge [MERGE] ","tokenStandart":""},"free":17.33178109}

class BalancePortfolio {
  BalancePortfolio({
      String? message, 
      bool? hasError, 
      dynamic error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  BalancePortfolio.fromJson(dynamic json) {
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

/// userId : 68857
/// coin : {"id":2,"rank":1,"name":"Merge","ticker":"MERGE","coinGeckoId":"merge","cryptoId":"MERGE","isToken":false,"blockchain":0,"minWithdraw":1,"imageBig":"9149137e7940687397146d176b2a62d9.png","imageSmall":"29cd07ad2090ac1be8890f9258bf60d7.png","isActive":true,"explorerUrl":"https://explorer.projectmerge.org/tx/{0}","requiredConfirmations":20,"feePercent":0,"fullName":"Merge [MERGE] ","tokenStandart":""}
/// free : 17.33178109

class Data {
  Data({
      int? userId, 
      Coin? coin, 
      double? free,}){
    _userId = userId;
    _coin = coin;
    _free = free;
}

  Data.fromJson(dynamic json) {
    _userId = json['userId'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _free = json['free'];
  }
  int? _userId;
  Coin? _coin;
  double? _free;

  int? get userId => _userId;
  Coin? get coin => _coin;
  double? get free => _free;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    map['free'] = _free;
    return map;
  }

}