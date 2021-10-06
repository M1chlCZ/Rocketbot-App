import 'Coin.dart';

class BalanceList {
  BalanceList({
      String? message, 
      bool? hasError, 
      dynamic error, 
      List<CoinBalance>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  BalanceList.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(CoinBalance.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  dynamic _error;
  List<CoinBalance>? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  dynamic get error => _error;
  List<CoinBalance>? get data => _data;

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

class CoinBalance {
  CoinBalance({
      int? userId, 
      Coin? coin,
      double? free,}){
    _userId = userId;
    _coin = coin;
    _free = free;
}

  CoinBalance.fromJson(dynamic json) {
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
