import 'coin.dart';

/// message : "Successfully executed."
/// hasError : false
/// error : null
/// data : [{"userId":68857,"coin":{"id":2,"rank":1,"name":"Merge","ticker":"MERGE","coinGeckoId":"merge","cryptoId":"MERGE","isToken":false,"blockchain":0,"minWithdraw":1,"imageBig":"9149137e7940687397146d176b2a62d9.png","imageSmall":"29cd07ad2090ac1be8890f9258bf60d7.png","isActive":true,"explorerUrl":"https://explorer.projectmerge.org/tx/{0}","requiredConfirmations":20,"feePercent":0,"fullName":"Merge [MERGE] ","tokenStandart":""},"amount":10,"transactionId":"cf9e28dd66e9ef86940c4f4a795f4866c0a067a1a92a3de698361440244d3a68","isConfirmed":false,"confirmations":7,"receivedAt":"2021-12-10T01:55:45","confirmedAt":null}]

class DepositsModel {
  DepositsModel({
      String? message, 
      bool? hasError, 
      dynamic error, 
      List<DataDeposits>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  DepositsModel.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DataDeposits.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  dynamic _error;
  List<DataDeposits>? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  dynamic get error => _error;
  List<DataDeposits>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// userId : 68857
/// coin : {"id":2,"rank":1,"name":"Merge","ticker":"MERGE","coinGeckoId":"merge","cryptoId":"MERGE","isToken":false,"blockchain":0,"minWithdraw":1,"imageBig":"9149137e7940687397146d176b2a62d9.png","imageSmall":"29cd07ad2090ac1be8890f9258bf60d7.png","isActive":true,"explorerUrl":"https://explorer.projectmerge.org/tx/{0}","requiredConfirmations":20,"feePercent":0,"fullName":"Merge [MERGE] ","tokenStandart":""}
/// amount : 10
/// transactionId : "cf9e28dd66e9ef86940c4f4a795f4866c0a067a1a92a3de698361440244d3a68"
/// isConfirmed : false
/// confirmations : 7
/// receivedAt : "2021-12-10T01:55:45"
/// confirmedAt : null

class DataDeposits {
  DataDeposits({
      int? userId, 
      Coin? coin, 
      double? amount,
      String? transactionId, 
      bool? isConfirmed, 
      int? confirmations, 
      String? receivedAt, 
      dynamic confirmedAt,}){
    _userId = userId;
    _coin = coin;
    _amount = amount;
    _transactionId = transactionId;
    _isConfirmed = isConfirmed;
    _confirmations = confirmations;
    _receivedAt = receivedAt;
    _confirmedAt = confirmedAt;
}

  DataDeposits.fromJson(dynamic json) {
    _userId = json['userId'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _amount = json['amount'];
    _transactionId = json['transactionId'];
    _isConfirmed = json['isConfirmed'];
    _confirmations = json['confirmations'];
    _receivedAt = json['receivedAt'];
    _confirmedAt = json['confirmedAt'];
  }
  int? _userId;
  Coin? _coin;
  double? _amount;
  String? _transactionId;
  bool? _isConfirmed;
  int? _confirmations;
  String? _receivedAt;
  dynamic _confirmedAt;

  int? get userId => _userId;
  Coin? get coin => _coin;
  double? get amount => _amount;
  String? get transactionId => _transactionId;
  bool? get isConfirmed => _isConfirmed;
  int? get confirmations => _confirmations;
  String? get receivedAt => _receivedAt;
  dynamic get confirmedAt => _confirmedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    map['amount'] = _amount;
    map['transactionId'] = _transactionId;
    map['isConfirmed'] = _isConfirmed;
    map['confirmations'] = _confirmations;
    map['receivedAt'] = _receivedAt;
    map['confirmedAt'] = _confirmedAt;
    return map;
  }

}