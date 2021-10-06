import 'package:rocketbot/Models/Coin.dart';
import 'package:rocketbot/Models/CoinList.dart';
import 'package:rocketbot/NetInterface/Interface.dart';

class CoinsList {
  NetInterface _helper = NetInterface();

  Future<List<Coin>?> fetchAllCoins() async {
    final response = await _helper.get("Coin/GetAllCoins");
    return CoinList.fromJson(response).data;
  }
}