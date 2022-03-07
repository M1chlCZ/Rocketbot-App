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
      String? depositAddr,}){
    _idCoin = idCoin;
    _depositAddr = depositAddr;
}

  Coins.fromJson(dynamic json) {
    _idCoin = json['idCoin'];
    _depositAddr = json['depositAddr'];
  }
  int? _idCoin;
  String? _depositAddr;

  int? get idCoin => _idCoin;
  String? get depositAddr => _depositAddr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCoin'] = _idCoin;
    map['depositAddr'] = _depositAddr;
    return map;
  }

}