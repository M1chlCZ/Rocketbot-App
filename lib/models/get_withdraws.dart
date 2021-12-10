import 'coin.dart';

/// message : "string"
/// hasError : true
/// error : "string"
/// data : [{"pgwIdentifier":"3fa85f64-5717-4562-b3fc-2c963f66afa6","userId":0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","coinGeckoId":"string","cryptoId":"string","isToken":true,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"feePercent":0,"fullName":"string","tokenStandart":"string"},"amount":0,"feeCoin":{"id":0,"rank":0,"name":"string","ticker":"string","coinGeckoId":"string","cryptoId":"string","isToken":true,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"feePercent":0,"fullName":"string","tokenStandart":"string"},"fee":0,"toAddress":"string","transactionId":"string","sent":true,"sentAt":"2021-12-09T21:57:50.701Z","chainConfirmed":true,"confirmedAt":"2021-12-09T21:57:50.701Z","failed":true,"createdAt":"2021-12-09T21:57:50.701Z","feePercent":0}]

class WithdrawalsModels {
  WithdrawalsModels({
      String? message, 
      bool? hasError, 
      String? error, 
      List<Data>? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  WithdrawalsModels.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _hasError;
  String? _error;
  List<Data>? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  List<Data>? get data => _data;

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

/// pgwIdentifier : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// userId : 0
/// coin : {"id":0,"rank":0,"name":"string","ticker":"string","coinGeckoId":"string","cryptoId":"string","isToken":true,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"feePercent":0,"fullName":"string","tokenStandart":"string"}
/// amount : 0
/// feeCoin : {"id":0,"rank":0,"name":"string","ticker":"string","coinGeckoId":"string","cryptoId":"string","isToken":true,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"feePercent":0,"fullName":"string","tokenStandart":"string"}
/// fee : 0
/// toAddress : "string"
/// transactionId : "string"
/// sent : true
/// sentAt : "2021-12-09T21:57:50.701Z"
/// chainConfirmed : true
/// confirmedAt : "2021-12-09T21:57:50.701Z"
/// failed : true
/// createdAt : "2021-12-09T21:57:50.701Z"
/// feePercent : 0

class Data {
  Data({
      String? pgwIdentifier, 
      int? userId, 
      Coin? coin, 
      double? amount,
      FeeCoin? feeCoin, 
      int? fee, 
      String? toAddress, 
      String? transactionId, 
      bool? sent, 
      String? sentAt, 
      bool? chainConfirmed, 
      String? confirmedAt, 
      bool? failed, 
      String? createdAt, 
      int? feePercent,}){
    _pgwIdentifier = pgwIdentifier;
    _userId = userId;
    _coin = coin;
    _amount = amount;
    _feeCoin = feeCoin;
    _fee = fee;
    _toAddress = toAddress;
    _transactionId = transactionId;
    _sent = sent;
    _sentAt = sentAt;
    _chainConfirmed = chainConfirmed;
    _confirmedAt = confirmedAt;
    _failed = failed;
    _createdAt = createdAt;
    _feePercent = feePercent;
}

  Data.fromCustom({
    String? pgwIdentifier,
    int? userId,
    Coin? coin,
    double? amount,
    FeeCoin? feeCoin,
    int? fee,
    String? toAddress,
    String? transactionId,
    bool? sent,
    String? sentAt,
    bool? chainConfirmed,
    String? confirmedAt,
    bool? failed,
    String? createdAt,
    int? feePercent,}){
    _pgwIdentifier = pgwIdentifier;
    _userId = userId;
    _coin = coin;
    _amount = amount;
    _feeCoin = feeCoin;
    _fee = fee;
    _toAddress = toAddress;
    _transactionId = transactionId;
    _sent = sent;
    _sentAt = sentAt;
    _chainConfirmed = chainConfirmed;
    _confirmedAt = confirmedAt;
    _failed = failed;
    _createdAt = createdAt;
    _feePercent = feePercent;
  }

  Data.fromJson(dynamic json) {
    _pgwIdentifier = json['pgwIdentifier'];
    _userId = json['userId'];
    _coin = json['coin'] != null ? Coin.fromJson(json['coin']) : null;
    _amount = json['amount'];
    _feeCoin = json['feeCoin'] != null ? FeeCoin.fromJson(json['feeCoin']) : null;
    _fee = json['fee'];
    _toAddress = json['toAddress'];
    _transactionId = json['transactionId'];
    _sent = json['sent'];
    _sentAt = json['sentAt'];
    _chainConfirmed = json['chainConfirmed'];
    _confirmedAt = json['confirmedAt'];
    _failed = json['failed'];
    _createdAt = json['createdAt'];
    _feePercent = json['feePercent'];
  }
  String? _pgwIdentifier;
  int? _userId;
  Coin? _coin;
  double? _amount;
  FeeCoin? _feeCoin;
  int? _fee;
  String? _toAddress;
  String? _transactionId;
  bool? _sent;
  String? _sentAt;
  bool? _chainConfirmed;
  String? _confirmedAt;
  bool? _failed;
  String? _createdAt;
  int? _feePercent;

  String? get pgwIdentifier => _pgwIdentifier;
  int? get userId => _userId;
  Coin? get coin => _coin;
  double? get amount => _amount;
  FeeCoin? get feeCoin => _feeCoin;
  int? get fee => _fee;
  String? get toAddress => _toAddress;
  String? get transactionId => _transactionId;
  bool? get sent => _sent;
  String? get sentAt => _sentAt;
  bool? get chainConfirmed => _chainConfirmed;
  String? get confirmedAt => _confirmedAt;
  bool? get failed => _failed;
  String? get createdAt => _createdAt;
  int? get feePercent => _feePercent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pgwIdentifier'] = _pgwIdentifier;
    map['userId'] = _userId;
    if (_coin != null) {
      map['coin'] = _coin?.toJson();
    }
    map['amount'] = _amount;
    if (_feeCoin != null) {
      map['feeCoin'] = _feeCoin?.toJson();
    }
    map['fee'] = _fee;
    map['toAddress'] = _toAddress;
    map['transactionId'] = _transactionId;
    map['sent'] = _sent;
    map['sentAt'] = _sentAt;
    map['chainConfirmed'] = _chainConfirmed;
    map['confirmedAt'] = _confirmedAt;
    map['failed'] = _failed;
    map['createdAt'] = _createdAt;
    map['feePercent'] = _feePercent;
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
/// feePercent : 0
/// fullName : "string"
/// tokenStandart : "string"

class FeeCoin {
  FeeCoin({
      int? id, 
      int? rank, 
      String? name, 
      String? ticker, 
      String? coinGeckoId, 
      String? cryptoId, 
      bool? isToken, 
      int? blockchain, 
      int? minWithdraw, 
      String? imageBig, 
      String? imageSmall, 
      bool? isActive, 
      String? explorerUrl, 
      int? requiredConfirmations, 
      int? feePercent, 
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

  FeeCoin.fromJson(dynamic json) {
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
  int? _minWithdraw;
  String? _imageBig;
  String? _imageSmall;
  bool? _isActive;
  String? _explorerUrl;
  int? _requiredConfirmations;
  int? _feePercent;
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
  int? get minWithdraw => _minWithdraw;
  String? get imageBig => _imageBig;
  String? get imageSmall => _imageSmall;
  bool? get isActive => _isActive;
  String? get explorerUrl => _explorerUrl;
  int? get requiredConfirmations => _requiredConfirmations;
  int? get feePercent => _feePercent;
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
