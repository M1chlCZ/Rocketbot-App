import 'package:flutter/foundation.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/netInterface/interface.dart';

class CoinBalances {
  final NetInterface _helper = NetInterface();

  Future<List<CoinBalance>?> fetchAllBalances({int sort = 0}) async {
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
    Map<int, dynamic> m = {0: _finalList, 1: sort};
    List<CoinBalance> _listSort = await compute(sortList, m);
    return _listSort;
  }

  List<CoinBalance> sortList(Map<int, dynamic> value) {
    List<CoinBalance> _finalList = value[0];
    int sort = value[1];
    if (sort == 0) {
      return _finalList;
    }else if(sort == 3) {
      _finalList.sort((a, b) {
        double A = a.free! * a.priceData!.prices!.usd!;
        double B = b.free! * b.priceData!.prices!.usd!;
        return B.compareTo(A);
      });
    } else if (sort == 2) {
      _finalList.sort((a, b) {
        var A = a.coin!.name;
        var B = b.coin!.name;
        return A.toString().toLowerCase().compareTo(B.toString().toLowerCase());
      });
    } else if (sort == 1) {
      _finalList.sort((a, b) {
        double A = a.free!;
        double B = b.free!;
        return B.compareTo(A);
      });
    }
    return _finalList;
  }
}
