import 'dart:async';

import 'package:rocketbot/models/transaction_data.dart';
import 'package:rocketbot/netInterface/api_response.dart';
import 'package:rocketbot/endpoints/get_transactions.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/get_withdraws.dart';

class TransactionBloc {
  final TransactionList _coinBalances = TransactionList();

  StreamController<ApiResponse<List<TransactionData>>>? _coinListController;

  StreamSink<ApiResponse<List<TransactionData>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<TransactionData>>> get coinsListStream =>
      _coinListController!.stream;

  TransactionBloc(Coin coin) {
    _coinListController = StreamController<ApiResponse<List<TransactionData>>>();
    fetchTransactionData(coin);
  }

  changeCoin (Coin coin) {
    fetchTransactionData(coin);
  }

  fetchTransactionData(Coin coin) async {
    coinsListSink.add(ApiResponse.loading('Fetching Transactions'));
    try {
      List<TransactionData>? _coins = await _coinBalances.fetchTransactions(coin.id!);
      coinsListSink.add(ApiResponse.completed(_coins));
    } catch (e) {
      coinsListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  dispose() {
    _coinListController?.close();
  }
}