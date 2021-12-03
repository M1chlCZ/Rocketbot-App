import 'package:rocketbot/Models/CoinGraph.dart';
import 'package:rocketbot/NetInterface/Interface.dart';

class CoinPrices {
  NetInterface _helper = NetInterface();

  Future<PriceData?> fetchCoinPrice(String coin) async {
    final response = await _helper.get("Coin/GetPriceData?CoinGeckoId=$coin&IncludeHistoryPrices=true&IncludeChange=true");
    return CoinGraph.fromJson(response,coin ).data;
  }
}