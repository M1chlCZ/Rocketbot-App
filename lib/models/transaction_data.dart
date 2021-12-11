import 'coin.dart';
import 'get_withdraws.dart';

class TransactionData {
  TransactionData({
    String? pgwIdentifier,
    int? userId,
    Coin? coin,
    double? amount,
    FeeCoin? feeCoin,
    double? usdPrice,
    int? fee,
    String? toAddress,
    String? transactionId,
    bool? sent,
    String? sentAt,
    bool? chainConfirmed,
    int? confirmations,
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
    _usdPrice = usdPrice;
    _sent = sent;
    _sentAt = sentAt;
    _confirmations = confirmations;
    _chainConfirmed = chainConfirmed;
    _confirmedAt = confirmedAt;
    _failed = failed;
    _createdAt = createdAt;
    _feePercent = feePercent;
  }

  TransactionData.fromCustom({
    String? pgwIdentifier,
    int? userId,
    Coin? coin,
    double? amount,
    FeeCoin? feeCoin,
    double? usdPrice,
    int? fee,
    String? toAddress,
    String? transactionId,
    bool? sent,
    String? sentAt,
    bool? chainConfirmed,
    int? confirmations,
    String? confirmedAt,
    bool? failed,
    String? receivedAt,
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
    _usdPrice = usdPrice;
    _sent = sent;
    _sentAt = sentAt;
    _receivedAt = receivedAt;
    _confirmations = confirmations;
    _chainConfirmed = chainConfirmed;
    _confirmedAt = confirmedAt;
    _failed = failed;
    _createdAt = createdAt;
    _feePercent = feePercent;
  }

  TransactionData.fromJson(dynamic json) {
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
  double? _usdPrice;
  bool? _sent;
  String? _sentAt;
  bool? _chainConfirmed;
  int? _confirmations;
  String? _confirmedAt;
  String? _receivedAt;
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
  int? get confirmations => _confirmations;
  double? get usdPrice => _usdPrice;
  String? get confirmedAt => _confirmedAt;
  String? get receivedAt => _receivedAt;
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