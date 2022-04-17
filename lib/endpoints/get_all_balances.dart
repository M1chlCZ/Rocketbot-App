import 'package:flutter/foundation.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/netInterface/interface.dart';

class CoinBalances {
  final NetInterface _helper = NetInterface();

  Future<List<CoinBalance>?> fetchAllBalances() async {
    final response = await _helper.get("User/GetBalances");
    final priceData = await _helper.get(
        "Coin/GetPriceData?IncludeHistoryPrices=true&IncludeVolume=false&IncludeMarketcap=false&IncludeChange=true");

    Map<String, dynamic> m = {"response": response, "priceData": priceData};
    List<CoinBalance> _finalList = await compute(doJob, m);
    return _finalList;
  }

  static List<CoinBalance> doJob(Map<String, dynamic> m) {
    dynamic response = m['response'];
    dynamic priceData = m['priceData'];

    List<CoinBalance>? r = BalanceList.fromJson(response).data;
    List<CoinBalance> _finalList = [];

    for (var item in r!) {
      try {
        var coinBal = item;
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
        var coinBal = item;
        _finalList.add(coinBal);
      }
    }
    return _finalList;
  }
}
