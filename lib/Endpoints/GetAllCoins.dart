import 'package:rocketbot/Models/Coin.dart';
import 'package:rocketbot/Models/CoinGraph.dart';
import 'package:rocketbot/Models/CoinList.dart';
import 'package:rocketbot/NetInterface/Interface.dart';

class CoinsList {
  NetInterface _helper = NetInterface();

  Future<List<Coin>?> fetchAllCoins() async {
    final response = await _helper.get("Coin/GetAllCoins");
    List<Coin>? r = CoinList.fromJson(response).data;
    List<Coin> finalList = [];

    await Future.forEach(r!, (item) async {
      print("shit");
      var coin = (item as Coin);
      String? coinID = coin.coinGeckoId;
      var res = await _helper.get("Coin/GetPriceData?coin=$coinID");
      PriceData? p = CoinGraph.fromJson(res).data;
      coin.setPriceData(p!);
      finalList.add(coin);
      });

    return finalList;
  }
}