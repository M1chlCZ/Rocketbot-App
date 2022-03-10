import 'package:rocketbot/support/globals.dart' as globals;

class PGWIdentifier {
  final int? id;
  final String? pgw;
  final int? txFinish;
  final int? idCoin;
  final double? amount;
  final String? depAddr;

  PGWIdentifier(
      {this.id,
      this.pgw,
      this.txFinish,
      this.idCoin,
      this.amount,
      this.depAddr});

  Map<String, dynamic> toMap() {
    return {
      globals.TS_ID: id,
      globals.TS_PWG: pgw,
      globals.TS_FINISHED: txFinish,
      globals.TS_COINID: idCoin,
      globals.TS_AMOUNT: amount,
      globals.TS_ADDR: depAddr
    };
  }

  factory PGWIdentifier.fromJson(Map<String, dynamic> json) {
    return PGWIdentifier(
        id: json[globals.TS_ID],
        pgw: json[globals.TS_PWG],
        txFinish: json[globals.TS_FINISHED],
        idCoin: json[globals.TS_COINID],
        amount: json[globals.TS_AMOUNT],
        depAddr: json[globals.TS_ADDR]);
  }

  String? getPGW() {
    return pgw;
  }

  int? getCoinID() {
    return idCoin;
  }

  int? getStatus() {
    return txFinish;
  }

  double? getAmount() {
    return amount;
  }

  String? getAddr() {
    return depAddr;
  }
}
