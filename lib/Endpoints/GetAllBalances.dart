import 'package:rocketbot/Models/BalanceList.dart';
import 'package:rocketbot/NetInterface/Interface.dart';

class CoinBalances {
  NetInterface _helper = NetInterface();

  Future<List<CoinBalance>?> fetchAllBalances() async {
    final response = await _helper.get("User/GetBalances");
    return BalanceList.fromJson(response).data;
  }
}