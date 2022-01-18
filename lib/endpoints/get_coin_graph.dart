import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/netInterface/interface.dart';

class CoinPrices {
  final NetInterface _helper = NetInterface();

  Future<PriceData?> fetchCoinPrice(String coin, int coinID) async {
    final response = await _helper.get("Coin/GetPriceData?CoinGeckoId=$coin&IncludeHistoryPrices=true&IncludeChange=true");
    return CoinGraph.fromJson(response,coinID.toString()).data;
  }
}