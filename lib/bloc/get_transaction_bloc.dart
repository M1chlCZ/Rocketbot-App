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

  TransactionBloc(Coin coin, {List<TransactionData>? list}) {
    _coinListController = StreamController<ApiResponse<List<TransactionData>>>();
    fetchTransactionData(coin, list: list);
  }

  changeCoin (Coin coin, {List<TransactionData>? list}) {
    fetchTransactionData(coin,list: list);
  }

  Future <void> fetchTransactionData(Coin coin, {List<TransactionData>? list, bool force = false}) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Transactions'));
    }
    try {
      List<TransactionData>? _coins;
      if(list == null ) {
        _coins = await _coinBalances.fetchTransactions(
            coin.id!, force);
      }else{
        _coins = list;
      }
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.completed(_coins));
      }
    } catch (e) {
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.error(e.toString()));
      }
      // print(e);
    }
  }

  dispose() {
    _coinListController?.close();
  }
}