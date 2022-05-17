import 'package:flutter/foundation.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/models/coin_list.dart';
import 'package:rocketbot/netInterface/interface.dart';

class CoinsList {
  final NetInterface _helper = NetInterface();

  Future<List<Coin>?> fetchAllCoins() async {
    try {
      final response = await _helper.get("Coin/GetAllCoins");
      List<Coin>? r = CoinList.fromJson(response).data;
      List<Coin> finalList = [];

      await Future.forEach(r!, (item) async {
            var coin = (item as Coin);
            String? coinID = coin.cryptoId;
            var res = await _helper.get("Coin/GetPriceData?coin=$coinID");
            PriceData? p = CoinGraph.fromJson(res, coinID!).data;
            coin.setPriceData(p!);
            finalList.add(coin);
            });

      return finalList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }
}