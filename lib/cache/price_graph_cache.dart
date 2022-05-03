import 'package:flutter/foundation.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/models/get_deposits.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/transaction_data.dart';

import '../NetInterface/interface.dart';
import '../models/balance_list.dart';

class PriceGraphCache extends TransactionData {
  static Duration? _cacheValidDuration;
  static DateTime? _lastFetchTime;
  static final Map<String, dynamic> _allRecords = {};

  PriceGraphCache() : super();

  static Future<void> refreshAllRecords({bool force = false}) async {
    if(_allRecords.isEmpty || force) {
      final NetInterface _helper = NetInterface();
      var f = await _helper.get("Coin/GetPriceData?IncludeHistoryPrices=true&IncludeVolume=false&IncludeMarketcap=false&IncludeChange=true");
      _allRecords.addAll(f);
      _lastFetchTime = DateTime.now();
    }
  }

  static Future<PriceData> getAllRecords(int coinID, {bool forceRefresh = false}) async {
    bool shouldRefreshFromApi =
        (_allRecords.isEmpty || null == _lastFetchTime || null == _cacheValidDuration || _lastFetchTime!.isAfter(DateTime.now().subtract(_cacheValidDuration!)) || forceRefresh);
    if (shouldRefreshFromApi) {
      await refreshAllRecords(force: true);
      _cacheValidDuration = const Duration(minutes: 10);
      _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
    }
    var data = PriceData.fromJson(_allRecords['data'][coinID.toString()]);
    return data;
  }
}
