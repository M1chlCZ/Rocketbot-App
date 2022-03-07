/// active : 1
/// amount : 0.2
/// hasError : false
/// stakesAmount : 2777.999999999944
/// status : "OK"

class StakeCheck {
  StakeCheck({
    int? active,
    double? amount,
    bool? hasError,
    double? stakesAmount,
    double? uncofirmed,
    String? status,}){
    _active = active;
    _amount = amount;
    _hasError = hasError;
    _stakesAmount = stakesAmount;
    _status = status;
  }

  StakeCheck.fromJson(dynamic json) {
    _active = json['active'];
    _amount = double.parse(json['amount'].toString());
    _hasError = json['hasError'];
    _stakesAmount = double.parse(json['stakesAmount'].toString());
    _status = json['status'];
    _unconfirmed = double.parse(json['uncofirmedAmount'].toString());
  }
  int? _active;
  double? _amount;
  bool? _hasError;
  double? _stakesAmount;
  String? _status;
  double? _unconfirmed;

  int? get active => _active;
  double? get amount => _amount;
  bool? get hasError => _hasError;
  double? get stakesAmount => _stakesAmount;
  String? get status => _status;
  double? get unconfirmed => _unconfirmed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['active'] = _active;
    map['amount'] = _amount;
    map['hasError'] = _hasError;
    map['stakesAmount'] = _stakesAmount;
    map['status'] = _status;
    return map;
  }

}