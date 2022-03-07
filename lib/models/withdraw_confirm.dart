import 'coin.dart';
import 'fee_coin.dart';

/// message : "string"
/// hasError : true
/// error : "string"
/// data : {"pgwIdentifier":"3fa85f64-5717-4562-b3fc-2c963f66afa6","userId":0,"coin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"amount":0,"feeCoin":{"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true},"fee":0,"toAddress":"string","transactionId":"string","sent":true,"sentAt":"2022-02-22T21:22:46.423Z","chainConfirmed":true,"confirmedAt":"2022-02-22T21:22:46.423Z","failed":true,"createdAt":"2022-02-22T21:22:46.423Z","feePercent":0}

class WithdrawConfirm {
  WithdrawConfirm({
      String? message, 
      bool? hasError, 
      String? error, 
      Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
}

  WithdrawConfirm.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  String? _error;
  Data? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
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

/// pgwIdentifier : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// userId : 0
/// coin : {"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true}
/// amount : 0
/// feeCoin : {"id":0,"rank":0,"name":"string","ticker":"string","cryptoId":"string","isToken":true,"contractAddress":"string","feePercent":0,"blockchain":0,"minWithdraw":0,"imageBig":"string","imageSmall":"string","bigImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","smallImageId":"3fa85f64-5717-4562-b3fc-2c963f66afa6","isActive":true,"explorerUrl":"string","requiredConfirmations":0,"fullName":"string","tokenStandart":"string","allowWithdraws":true,"allowDeposits":true}
/// fee : 0
/// toAddress : "string"
/// transactionId : "string"
/// sent : true
/// sentAt : "2022-02-22T21:22:46.423Z"
/// chainConfirmed : true
/// confirmedAt : "2022-02-22T21:22:46.423Z"
/// failed : true
/// createdAt : "2022-02-22T21:22:46.423Z"
/// feePercent : 0

class Data {
  Data({
      String? pgwIdentifier, 
      int? userId, 
      Coin? coin, 
      double? amount,
      FeeCoin? feeCoin, 
      double? fee,
      String? toAddress, 
      String? transactionId, 
      bool? sent, 
      String? sentAt, 
      bool? chainConfirmed, 
      String? confirmedAt, 
      bool? failed, 
      String? createdAt, 
      double? feePercent,}){
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
  double? _fee;
  String? _toAddress;
  String? _transactionId;
  bool? _sent;
  String? _sentAt;
  bool? _chainConfirmed;
  String? _confirmedAt;
  bool? _failed;
  String? _createdAt;
  double? _feePercent;

  String? get pgwIdentifier => _pgwIdentifier;
  int? get userId => _userId;
  Coin? get coin => _coin;
  double? get amount => _amount;
  FeeCoin? get feeCoin => _feeCoin;
  double? get fee => _fee;
  String? get toAddress => _toAddress;
  String? get transactionId => _transactionId;
  bool? get sent => _sent;
  String? get sentAt => _sentAt;
  bool? get chainConfirmed => _chainConfirmed;
  String? get confirmedAt => _confirmedAt;
  bool? get failed => _failed;
  String? get createdAt => _createdAt;
  double? get feePercent => _feePercent;

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