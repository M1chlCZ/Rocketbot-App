import 'package:rocketbot/Models/coin.dart';
import 'package:rocketbot/Models/coin_graph.dart';
import 'package:rocketbot/Models/coin_list.dart';
import 'package:rocketbot/NetInterface/interface.dart';

class CoinsList {
  final NetInterface _helper = NetInterface();

  Future<List<Coin>?> fetchAllCoins() async {
    final response = await _helper.get("Coin/GetAllCoins");
    List<Coin>? r = CoinList.fromJson(response).data;
    List<Coin> finalList = [];

    await Future.forEach(r!, (item) async {
      print("shit");
      var coin = (item as Coin);
      String? coinID = coin.coinGeckoId;
      var res = await _helper.get("Coin/GetPriceData?coin=$coinID");
      PriceData? p = CoinGraph.fromJson(res, coinID!).data;
      coin.setPriceData(p!);
      finalList.add(coin);
      });

    return finalList;
  }
}