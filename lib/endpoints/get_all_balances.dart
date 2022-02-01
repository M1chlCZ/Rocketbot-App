import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/netInterface/interface.dart';

class CoinBalances {
  final NetInterface _helper = NetInterface();

  Future<List<CoinBalance>?> fetchAllBalances() async {
    final response = await _helper.get("User/GetBalances");
    final priceData = await _helper.get(
        "Coin/GetPriceData?IncludeHistoryPrices=true&IncludeVolume=true&IncludeMarketcap=true&IncludeChange=true");
    List<CoinBalance>? r = BalanceList.fromJson(response).data;
    List<CoinBalance> _finalList = [];

    await Future.forEach(r!, (item) async {
      try {
        var coinBal = (item as CoinBalance);
        var coin = coinBal.coin;
        var coinID = coin!.id;
        final price = priceData['data'][coinID!.toString()];
        if (price == null) {
          // print("null");
          _finalList.add(coinBal);
        } else {
          PriceData? p = PriceData.fromJson(price);
          coinBal.setPriceData(p);
          _finalList.add(coinBal);

        }
      } catch (e) {
        var coinBal = (item as CoinBalance);
        _finalList.add(coinBal);
      }
    });
    return _finalList;
  }
}
