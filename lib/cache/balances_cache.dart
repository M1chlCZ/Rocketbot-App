import 'package:flutter/foundation.dart';
import 'package:rocketbot/models/coin_graph.dart';

import '../NetInterface/interface.dart';
import '../models/balance_list.dart';

class BalanceCache extends BalanceList {
  static Duration? _cacheValidDuration;
  static DateTime? _lastFetchTime;
  static dynamic _allRecords = {};

  BalanceCache() : super();

  static Future<void> _refreshAllRecords() async {
    final NetInterface _helper = NetInterface();
    final response = await _helper.get("User/GetBalances");
    final priceData = await _helper.get(
        "Coin/GetPriceData?IncludeHistoryPrices=true&IncludeVolume=false&IncludeMarketcap=false&IncludeChange=true");
    Map<String, dynamic> m = {"response": response, "priceData": priceData};
    List<CoinBalance> _finalList = await compute(doJob, m);

    _allRecords = _finalList;
    _lastFetchTime = DateTime.now();
  }

  static Future<List<CoinBalance>> getAllRecords({bool forceRefresh = false}) async {
    bool shouldRefreshFromApi = (null == _allRecords ||
        null == _lastFetchTime ||
        _lastFetchTime!
            .isAfter(DateTime.now().subtract(_cacheValidDuration!)) ||
        forceRefresh);
    if (shouldRefreshFromApi) {
      await _refreshAllRecords();
      _cacheValidDuration = const Duration(minutes: 10);
      _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
    }
    return _allRecords;
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
