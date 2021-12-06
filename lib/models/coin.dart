import 'package:rocketbot/Models/coin_graph.dart';

class Coin {
  Coin({
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
    String? fullName,
    PriceData? priceData,
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
    _fullName = fullName;
    _tokenStandart = tokenStandart;
  }

  Coin.fromJson(dynamic json) {
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
  String? _fullName;
  String? _tokenStandart;
  PriceData? _priceData;

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
  String? get fullName => _fullName;
  String? get tokenStandart => _tokenStandart;
  PriceData? get priceData => _priceData;


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
    map['fullName'] = _fullName;
    map['tokenStandart'] = _tokenStandart;
    return map;
  }

  void setPriceData(PriceData p) {
    this._priceData = p;
  }

}