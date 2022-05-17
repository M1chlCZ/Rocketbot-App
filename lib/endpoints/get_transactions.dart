import 'package:rocketbot/cache/transaction_cache.dart';
import 'package:rocketbot/models/transaction_data.dart';

class TransactionList {
  Future<List<TransactionData>?> fetchTransactions(int coinID, bool force) async {
    Future<List<TransactionData>?> finalList =
        TransactionCache.getAllRecords(coinID, forceRefresh: force);
    return finalList;
  }
}
