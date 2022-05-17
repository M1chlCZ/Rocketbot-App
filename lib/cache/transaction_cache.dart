import 'package:flutter/foundation.dart';
import 'package:rocketbot/models/get_deposits.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/transaction_data.dart';

import '../NetInterface/interface.dart';

class TransactionCache extends TransactionData {
  static Duration? _cacheValidDuration;
  static DateTime? _lastFetchTime;
  static final Map<String,List<TransactionData>> _allRecords = {};

  TransactionCache() : super();

  static Future<void> _refreshAllRecords(int coinID) async {
    final NetInterface helper = NetInterface();
    final deposits = await helper.get("Transfers/GetDeposits?page=1&pageSize=50&coinId=$coinID");
    final withdrawals = await helper.get("Transfers/GetWithdraws?page=1&pageSize=50&coinId=$coinID");
    // final price = await _helper.get("Coin/GetPriceData?coinId=$coinID&IncludeHistoryPrices=false&IncludeVolume=false&IncludeMarketcap=false&IncludeChange=true");

    List<DataWithdrawals>? withRld = WithdrawalsModels.fromJson(withdrawals).data;
    List<DataDeposits>? dep = DepositsModel.fromJson(deposits).data;
    List<TransactionData> finalList = [];
    await Future.forEach(dep!, (item) async {
      try {
        var it = (item as DataDeposits);
        // if(priceValue == null) {
        //   CoinGraph cg = CoinGraph.fromJson(price, item.coin!.id!.toString());
        //   priceValue = cg.data!.prices!.usd!.toDouble();
        // }
        TransactionData d = TransactionData.fromCustom(
            coin: it.coin,
            amount: it.amount,
            receivedAt: it.receivedAt,
            transactionId: it.transactionId,
            chainConfirmed: it.isConfirmed,
            confirmations: it.confirmations,
            usdPrice: 0.0);
        finalList.add(d);

      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    await Future.forEach(withRld!, (item) {
      try {
        var it = (item as DataWithdrawals);
        // if(priceValue == null) {
        //   CoinGraph cg = CoinGraph.fromJson(price, item.coin!.cryptoId!);
        //   priceValue = cg.data!.prices!.usd!.toDouble();
        // }
        TransactionData d = TransactionData.fromCustom(
          coin: it.coin,
          amount: it.amount,
          toAddress: it.toAddress,
          receivedAt: it.createdAt,
          transactionId: it.transactionId,
          chainConfirmed: it.chainConfirmed,
          usdPrice: 0.0,
        );
        finalList.add(d);
      }catch(e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
    finalList.sort((a,b) {
      var A = DateTime.parse(a.receivedAt!);
      var B = DateTime.parse(b.receivedAt!);
      return B.compareTo(A);
    });

    _allRecords['$coinID'] = finalList;
    _lastFetchTime = DateTime.now();
  }

  static Future<List<TransactionData>?> getAllRecords(int coinID,{bool forceRefresh = false}) async {
    bool shouldRefreshFromApi = (null == _allRecords['$coinID'] ||
        null == _lastFetchTime ||
        _lastFetchTime!
            .isAfter(DateTime.now().subtract(_cacheValidDuration!)) ||
        forceRefresh);
    if (shouldRefreshFromApi) {
      await _refreshAllRecords(coinID);
      _cacheValidDuration = const Duration(minutes: 5);
      _lastFetchTime = DateTime.fromMillisecondsSinceEpoch(0);
    }
    return _allRecords['$coinID'];
  }
}
