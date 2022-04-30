import 'package:rocketbot/NetInterface/interface.dart';
import 'package:rocketbot/cache/transaction_cache.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/models/get_deposits.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/transaction_data.dart';

class TransactionList {
  Future<List<TransactionData>?> fetchTransactions(int coinID, bool force) async {
    Future<List<TransactionData>?> _finalList =
        TransactionCache.getAllRecords(coinID, forceRefresh: force);
    return _finalList;
  }
}
