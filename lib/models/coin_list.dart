import 'coin.dart';

class CoinList {
  CoinList({
      String? message, 
      bool? hasError, 
      String? error, 
      List<Coin>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  CoinList.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Coin.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  String? _error;
  List<Coin>? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  List<Coin>? get data => _data;

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

/// id : 0
/// rank : 0
/// name : "string"
/// ticker : "string"
/// coinGeckoId : "string"
/// cryptoId : "string"
/// isToken : true
/// blockchain : 0
/// minWithdraw : 0
/// imageBig : "string"
/// imageSmall : "string"
/// isActive : true
/// explorerUrl : "string"
/// requiredConfirmations : 0
/// fullName : "string"
/// tokenStandart : "string"

