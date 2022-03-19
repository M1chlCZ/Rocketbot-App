import 'package:intl/intl.dart';
import 'package:rocketbot/models/stake_data.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/support/utils.dart';

class StakeList {
  final NetInterface _interface = NetInterface();

  Future<StakingData> getStakingData(int coinID, int type) async {
    Map<String, dynamic> m = {
      "idCoin": coinID,
      "type": type,
      "datetime": type == 1 ? DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()) : Utils.getUTC()
    };
    var rs = await _interface.post("stake/list", m, pos: true);
    StakingData st = StakingData.fromJson(rs);
    return st;
  }
}