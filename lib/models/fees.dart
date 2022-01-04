/// message : "Successfully executed."
/// hasError : false
/// error : null
/// data : {"crypto":{"id":9,"rank":8,"name":"Bitcoin","ticker":"BTC","coinGeckoId":"bitcoin","cryptoId":"BTC","isToken":false,"blockchain":0,"minWithdraw":0.00009,"imageBig":"5dca8e8ac1e4a48e24d73c2c5e20f090.png","imageSmall":"9fa373c6181d5698d1d8ad8a957c9d54.png","isActive":true,"explorerUrl":"https://www.blockchain.com/btc/tx/{0}","requiredConfirmations":4,"feePercent":0,"fullName":"Bitcoin [BTC] ","tokenStandart":""},"feeCrypto":{"id":9,"rank":8,"name":"Bitcoin","ticker":"BTC","coinGeckoId":"bitcoin","cryptoId":"BTC","isToken":false,"blockchain":0,"minWithdraw":0.00009,"imageBig":"5dca8e8ac1e4a48e24d73c2c5e20f090.png","imageSmall":"9fa373c6181d5698d1d8ad8a957c9d54.png","isActive":true,"explorerUrl":"https://www.blockchain.com/btc/tx/{0}","requiredConfirmations":4,"feePercent":0,"fullName":"Bitcoin [BTC] ","tokenStandart":""},"fee":0.000105}

class Fees {
  Fees({
      String? message, 
      bool? hasError, 
      dynamic error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  Fees.fromJson(dynamic json) {
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

/// crypto : {"id":9,"rank":8,"name":"Bitcoin","ticker":"BTC","coinGeckoId":"bitcoin","cryptoId":"BTC","isToken":false,"blockchain":0,"minWithdraw":0.00009,"imageBig":"5dca8e8ac1e4a48e24d73c2c5e20f090.png","imageSmall":"9fa373c6181d5698d1d8ad8a957c9d54.png","isActive":true,"explorerUrl":"https://www.blockchain.com/btc/tx/{0}","requiredConfirmations":4,"feePercent":0,"fullName":"Bitcoin [BTC] ","tokenStandart":""}
/// feeCrypto : {"id":9,"rank":8,"name":"Bitcoin","ticker":"BTC","coinGeckoId":"bitcoin","cryptoId":"BTC","isToken":false,"blockchain":0,"minWithdraw":0.00009,"imageBig":"5dca8e8ac1e4a48e24d73c2c5e20f090.png","imageSmall":"9fa373c6181d5698d1d8ad8a957c9d54.png","isActive":true,"explorerUrl":"https://www.blockchain.com/btc/tx/{0}","requiredConfirmations":4,"feePercent":0,"fullName":"Bitcoin [BTC] ","tokenStandart":""}
/// fee : 0.000105

class Data {
  Data({
      Crypto? crypto, 
      FeeCrypto? feeCrypto, 
      double? fee,}){
    _crypto = crypto;
    _feeCrypto = feeCrypto;
    _fee = fee;
}

  Data.fromJson(dynamic json) {
    _crypto = json['crypto'] != null ? Crypto.fromJson(json['crypto']) : null;
    _feeCrypto = json['feeCrypto'] != null ? FeeCrypto.fromJson(json['feeCrypto']) : null;
    _fee = json['fee'];
  }
  Crypto? _crypto;
  FeeCrypto? _feeCrypto;
  double? _fee;

  Crypto? get crypto => _crypto;
  FeeCrypto? get feeCrypto => _feeCrypto;
  double? get fee => _fee;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_crypto != null) {
      map['crypto'] = _crypto?.toJson();
    }
    if (_feeCrypto != null) {
      map['feeCrypto'] = _feeCrypto?.toJson();
    }
    map['fee'] = _fee;
    return map;
  }

}

/// id : 9
/// rank : 8
/// name : "Bitcoin"
/// ticker : "BTC"
/// coinGeckoId : "bitcoin"
/// cryptoId : "BTC"
/// isToken : false
/// blockchain : 0
/// minWithdraw : 0.00009
/// imageBig : "5dca8e8ac1e4a48e24d73c2c5e20f090.png"
/// imageSmall : "9fa373c6181d5698d1d8ad8a957c9d54.png"
/// isActive : true
/// explorerUrl : "https://www.blockchain.com/btc/tx/{0}"
/// requiredConfirmations : 4
/// feePercent : 0
/// fullName : "Bitcoin [BTC] "
/// tokenStandart : ""

class FeeCrypto {
  FeeCrypto({
      int? id, 
      int? rank, 
      String? name, 
      String? ticker, 
      String? coinGeckoId, 
      String? cryptoId, 
      bool? isToken, 
      int? blockchain, 
      double? minWithdraw, 
      String? imageBig, 
      String? imageSmall, 
      bool? isActive, 
      String? explorerUrl, 
      int? requiredConfirmations, 
      double? feePercent,
      String? fullName, 
      String? tokenStandart,}){
    _id = id;
    _rank = rank;
    _name = name;
    _ticker = ticker;
    _coinGeckoId = coinGeckoId;
    _cryptoId = cryptoId;
    _isToken = isToken;
    _blockchain = blockchain;
    _minWithdraw = minWithdraw;
    _imageBig = imageBig;
    _imageSmall = imageSmall;
    _isActive = isActive;
    _explorerUrl = explorerUrl;
    _requiredConfirmations = requiredConfirmations;
    _feePercent = feePercent;
    _fullName = fullName;
    _tokenStandart = tokenStandart;
}

  FeeCrypto.fromJson(dynamic json) {
    _id = json['id'];
    _rank = json['rank'];
    _name = json['name'];
    _ticker = json['ticker'];
    _coinGeckoId = json['coinGeckoId'];
    _cryptoId = json['cryptoId'];
    _isToken = json['isToken'];
    _blockchain = json['blockchain'];
    _minWithdraw = json['minWithdraw'];
    _imageBig = json['imageBig'];
    _imageSmall = json['imageSmall'];
    _isActive = json['isActive'];
    _explorerUrl = json['explorerUrl'];
    _requiredConfirmations = json['requiredConfirmations'];
    _feePercent = json['feePercent'];
    _fullName = json['fullName'];
    _tokenStandart = json['tokenStandart'];
  }
  int? _id;
  int? _rank;
  String? _name;
  String? _ticker;
  String? _coinGeckoId;
  String? _cryptoId;
  bool? _isToken;
  int? _blockchain;
  double? _minWithdraw;
  String? _imageBig;
  String? _imageSmall;
  bool? _isActive;
  String? _explorerUrl;
  int? _requiredConfirmations;
  double? _feePercent;
  String? _fullName;
  String? _tokenStandart;

  int? get id => _id;
  int? get rank => _rank;
  String? get name => _name;
  String? get ticker => _ticker;
  String? get coinGeckoId => _coinGeckoId;
  String? get cryptoId => _cryptoId;
  bool? get isToken => _isToken;
  int? get blockchain => _blockchain;
  double? get minWithdraw => _minWithdraw;
  String? get imageBig => _imageBig;
  String? get imageSmall => _imageSmall;
  bool? get isActive => _isActive;
  String? get explorerUrl => _explorerUrl;
  int? get requiredConfirmations => _requiredConfirmations;
  double? get feePercent => _feePercent;
  String? get fullName => _fullName;
  String? get tokenStandart => _tokenStandart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['rank'] = _rank;
    map['name'] = _name;
    map['ticker'] = _ticker;
    map['coinGeckoId'] = _coinGeckoId;
    map['cryptoId'] = _cryptoId;
    map['isToken'] = _isToken;
    map['blockchain'] = _blockchain;
    map['minWithdraw'] = _minWithdraw;
    map['imageBig'] = _imageBig;
    map['imageSmall'] = _imageSmall;
    map['isActive'] = _isActive;
    map['explorerUrl'] = _explorerUrl;
    map['requiredConfirmations'] = _requiredConfirmations;
    map['feePercent'] = _feePercent;
    map['fullName'] = _fullName;
    map['tokenStandart'] = _tokenStandart;
    return map;
  }

}

/// id : 9
/// rank : 8
/// name : "Bitcoin"
/// ticker : "BTC"
/// coinGeckoId : "bitcoin"
/// cryptoId : "BTC"
/// isToken : false
/// blockchain : 0
/// minWithdraw : 0.00009
/// imageBig : "5dca8e8ac1e4a48e24d73c2c5e20f090.png"
/// imageSmall : "9fa373c6181d5698d1d8ad8a957c9d54.png"
/// isActive : true
/// explorerUrl : "https://www.blockchain.com/btc/tx/{0}"
/// requiredConfirmations : 4
/// feePercent : 0
/// fullName : "Bitcoin [BTC] "
/// tokenStandart : ""

class Crypto {
  Crypto({
      int? id, 
      int? rank, 
      String? name, 
      String? ticker, 
      String? coinGeckoId, 
      String? cryptoId, 
      bool? isToken, 
      int? blockchain, 
      double? minWithdraw, 
      String? imageBig, 
      String? imageSmall, 
      bool? isActive, 
      String? explorerUrl, 
      int? requiredConfirmations, 
      double? feePercent,
      String? fullName,
      String? tokenStandart,}){
    _id = id;
    _rank = rank;
    _name = name;
    _ticker = ticker;
    _coinGeckoId = coinGeckoId;
    _cryptoId = cryptoId;
    _isToken = isToken;
    _blockchain = blockchain;
    _minWithdraw = minWithdraw;
    _imageBig = imageBig;
    _imageSmall = imageSmall;
    _isActive = isActive;
    _explorerUrl = explorerUrl;
    _requiredConfirmations = requiredConfirmations;
    _feePercent = feePercent;
    _fullName = fullName;
    _tokenStandart = tokenStandart;
}

  Crypto.fromJson(dynamic json) {
    _id = json['id'];
    _rank = json['rank'];
    _name = json['name'];
    _ticker = json['ticker'];
    _coinGeckoId = json['coinGeckoId'];
    _cryptoId = json['cryptoId'];
    _isToken = json['isToken'];
    _blockchain = json['blockchain'];
    _minWithdraw = json['minWithdraw'];
    _imageBig = json['imageBig'];
    _imageSmall = json['imageSmall'];
    _isActive = json['isActive'];
    _explorerUrl = json['explorerUrl'];
    _requiredConfirmations = json['requiredConfirmations'];
    _feePercent = json['feePercent'];
    _fullName = json['fullName'];
    _tokenStandart = json['tokenStandart'];
  }
  int? _id;
  int? _rank;
  String? _name;
  String? _ticker;
  String? _coinGeckoId;
  String? _cryptoId;
  bool? _isToken;
  int? _blockchain;
  double? _minWithdraw;
  String? _imageBig;
  String? _imageSmall;
  bool? _isActive;
  String? _explorerUrl;
  int? _requiredConfirmations;
  double? _feePercent;
  String? _fullName;
  String? _tokenStandart;

  int? get id => _id;
  int? get rank => _rank;
  String? get name => _name;
  String? get ticker => _ticker;
  String? get coinGeckoId => _coinGeckoId;
  String? get cryptoId => _cryptoId;
  bool? get isToken => _isToken;
  int? get blockchain => _blockchain;
  double? get minWithdraw => _minWithdraw;
  String? get imageBig => _imageBig;
  String? get imageSmall => _imageSmall;
  bool? get isActive => _isActive;
  String? get explorerUrl => _explorerUrl;
  int? get requiredConfirmations => _requiredConfirmations;
  double? get feePercent => _feePercent;
  String? get fullName => _fullName;
  String? get tokenStandart => _tokenStandart;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['rank'] = _rank;
    map['name'] = _name;
    map['ticker'] = _ticker;
    map['coinGeckoId'] = _coinGeckoId;
    map['cryptoId'] = _cryptoId;
    map['isToken'] = _isToken;
    map['blockchain'] = _blockchain;
    map['minWithdraw'] = _minWithdraw;
    map['imageBig'] = _imageBig;
    map['imageSmall'] = _imageSmall;
    map['isActive'] = _isActive;
    map['explorerUrl'] = _explorerUrl;
    map['requiredConfirmations'] = _requiredConfirmations;
    map['feePercent'] = _feePercent;
    map['fullName'] = _fullName;
    map['tokenStandart'] = _tokenStandart;
    return map;
  }

}