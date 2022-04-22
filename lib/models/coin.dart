import 'dart:core';

import 'package:rocketbot/models/coin_graph.dart';

/// id : 2
/// rank : 1
/// name : "Merge"
/// ticker : "MERGE"
/// cryptoId : "MERGE"
/// isToken : true
/// contractAddress : "null"
/// feePercent : 2.5
/// blockchain : 3
/// minWithdraw : 0.1
/// imageBig : "9149137e7940687397146d176b2a62d9.png"
/// imageSmall : "29cd07ad2090ac1be8890f9258bf60d7.png"
/// isActive : true
/// explorerUrl : "https://explorer.projectmerge.org/"
/// requiredConfirmations : 20
/// fullName : "Merge [MERGE] BEP20"
/// tokenStandart : "BEP20"
/// allowWithdraws : true
/// allowDeposits : true

class Coin {
  Coin({
      int? id, 
      int? rank, 
      String? name, 
      String? ticker, 
      String? cryptoId, 
      bool? isToken, 
      String? contractAddress, 
      double? feePercent, 
      int? blockchain, 
      double? minWithdraw, 
      String? imageBig, 
      String? imageSmall,
    String? bigImageId,
    String? smallImageId,
      bool? isActive, 
      String? explorerUrl, 
      int? requiredConfirmations, 
      String? fullName, 
      String? tokenStandart, 
      bool? allowWithdraws,
    PriceData? priceData,
      bool? allowDeposits,}){
    _id = id;
    _rank = rank;
    _name = name;
    _ticker = ticker;
    _cryptoId = cryptoId;
    _isToken = isToken;
    _contractAddress = contractAddress;
    _feePercent = feePercent;
    _blockchain = blockchain;
    _minWithdraw = minWithdraw;
    _imageBig = imageBig;
    _imageSmall = imageSmall;
    _imageSmallid = smallImageId;
    _imageBigid = bigImageId;
    _isActive = isActive;
    _explorerUrl = explorerUrl;
    _requiredConfirmations = requiredConfirmations;
    _fullName = fullName;
    _tokenStandart = tokenStandart;
    _allowWithdraws = allowWithdraws;
    _priceData = priceData;
    _allowDeposits = allowDeposits;
}

  Coin.fromJson(dynamic json) {
    _id = json['id'];
    _rank = json['rank'];
    _name = json['name'];
    _ticker = json['ticker'];
    _cryptoId = json['cryptoId'];
    _isToken = json['isToken'];
    _contractAddress = json['contractAddress'];
    _feePercent = json['feePercent'];
    _blockchain = json['blockchain'];
    _minWithdraw = json['minWithdraw'];
    _imageBig = json['imageBig'];
    _imageSmall = json['imageSmall'];
    _imageSmallid = json['smallImageId'];
    _imageBigid = json['bigImageId'];
    _isActive = json['isActive'];
    _explorerUrl = json['explorerUrl'];
    _requiredConfirmations = json['requiredConfirmations'];
    _fullName = json['fullName'];
    _tokenStandart = json['tokenStandart'];
    _allowWithdraws = json['allowWithdraws'];
    _allowDeposits = json['allowDeposits'];
  }
  int? _id;
  int? _rank;
  String? _name;
  String? _ticker;
  String? _cryptoId;
  bool? _isToken;
  String? _contractAddress;
  double? _feePercent;
  int? _blockchain;
  double? _minWithdraw;
  String? _imageBig;
  String? _imageSmall;
  String? _imageSmallid;
  String? _imageBigid;
  bool? _isActive;
  String? _explorerUrl;
  int? _requiredConfirmations;
  String? _fullName;
  String? _tokenStandart;
  PriceData? _priceData;
  bool? _allowWithdraws;
  bool? _allowDeposits;

  int? get id => _id;
  int? get rank => _rank;
  String? get name => _name;
  String? get ticker => _ticker;
  String? get cryptoId => _cryptoId;
  bool? get isToken => _isToken;
  String? get contractAddress => _contractAddress;
  double? get feePercent => _feePercent;
  int? get blockchain => _blockchain;
  double? get minWithdraw => _minWithdraw;
  String? get imageBig => _imageBig;
  String? get imageSmall => _imageSmall;
  String? get imageBigid => _imageBigid;
  String? get imageSmallid => _imageSmallid;
  bool? get isActive => _isActive;
  String? get explorerUrl => _explorerUrl;
  int? get requiredConfirmations => _requiredConfirmations;
  String? get fullName => _fullName;
  String? get tokenStandart => _tokenStandart;
  bool? get allowWithdraws => _allowWithdraws;
  bool? get allowDeposits => _allowDeposits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['rank'] = _rank;
    map['name'] = _name;
    map['ticker'] = _ticker;
    map['cryptoId'] = _cryptoId;
    map['isToken'] = _isToken;
    map['contractAddress'] = _contractAddress;
    map['feePercent'] = _feePercent;
    map['blockchain'] = _blockchain;
    map['minWithdraw'] = _minWithdraw;
    map['imageBig'] = _imageBig;
    map['imageSmall'] = _imageSmall;
    map['smallImageId'] = _imageSmallid;
    map['bigImageId'] = _imageBigid;
    map['isActive'] = _isActive;
    map['explorerUrl'] = _explorerUrl;
    map['requiredConfirmations'] = _requiredConfirmations;
    map['fullName'] = _fullName;
    map['tokenStandart'] = _tokenStandart;
    map['allowWithdraws'] = _allowWithdraws;
    map['allowDeposits'] = _allowDeposits;
    return map;
  }

  void setPriceData(PriceData p) {
    _priceData = p;
  }

}