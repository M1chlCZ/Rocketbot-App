import 'package:rocketbot/Models/BalanceList.dart';
import 'package:rocketbot/Models/CoinGraph.dart';
import 'package:rocketbot/NetInterface/Interface.dart';

class CoinBalances {
  NetInterface _helper = NetInterface();

  Future<List<CoinBalance>?> fetchAllBalances() async {
    final response = await _helper.get("User/GetBalances");
    final priceData = await _helper.get("Coin/GetPriceData?IncludeHistoryPrices=false&IncludeVolume=false&IncludeMarketcap=true&IncludeChange=true");
    List<CoinBalance>? r = BalanceList.fromJson(response).data;
    List<CoinBalance> finalList = [];

    await Future.forEach(r!, (item) async {
      try {
        var coinBal = (item as CoinBalance);
        var coin = coinBal.coin;
        String? coinID = coin!.coinGeckoId;
        final price = priceData['data'][coinID!];
        PriceData? p = PriceData.fromJson(price);
        coinBal.setPriceData(p);
        finalList.add(coinBal);

      } catch (e) {
        // print(e);
      }
    });

    return finalList;
  }
}
