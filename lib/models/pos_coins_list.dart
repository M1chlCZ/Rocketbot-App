/// coins : [{"idCoin":69,"depositAddr":""},{"idCoin":2,"depositAddr":"MDQ7CDCqUi1dmSZhHb4NT7sTymYRZqCLsB"}]
/// hasError : false
/// status : "OK"

class PosCoinsList {
  PosCoinsList({
      List<Coins>? coins, 
      bool? hasError, 
      String? status,}){
    _coins = coins;
    _hasError = hasError;
    _status = status;
}

  PosCoinsList.fromJson(dynamic json) {
    if (json['coins'] != null) {
      _coins = [];
      json['coins'].forEach((v) {
        _coins?.add(Coins.fromJson(v));
      });
    }
    _hasError = json['hasError'];
    _status = json['status'];
  }
  List<Coins>? _coins;
  bool? _hasError;
  String? _status;

  List<Coins>? get coins => _coins;
  bool? get hasError => _hasError;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_coins != null) {
      map['coins'] = _coins?.map((v) => v.toJson()).toList();
    }
    map['hasError'] = _hasError;
    map['status'] = _status;
    return map;
  }

}

/// idCoin : 69
/// depositAddr : ""

class Coins {
  Coins({
      int? idCoin, 
      String? depositAddr,
  double? amount}){
    _idCoin = idCoin;
    _depositAddr = depositAddr;
    _amount = amount;
}

  Coins.fromJson(dynamic json) {
    _idCoin = json['idCoin'];
    _depositAddr = json['depositAddr'];
    _amount = double.parse(json['amount'].toString());
  }
  int? _idCoin;
  String? _depositAddr;
  double? _amount;

  int? get idCoin => _idCoin;
  String? get depositAddr => _depositAddr;
  double? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCoin'] = _idCoin;
    map['depositAddr'] = _depositAddr;
    map['amount'] = _amount;
    return map;
  }

}