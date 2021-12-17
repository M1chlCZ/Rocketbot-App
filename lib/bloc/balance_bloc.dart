import 'dart:async';

import 'package:rocketbot/endpoints/get_all_balances.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/netInterface/api_response.dart';

class BalancesBloc {
  final CoinBalances _balanceList = CoinBalances();

  StreamController<ApiResponse<List<CoinBalance>>>? _coinListController;

  StreamSink<ApiResponse<List<CoinBalance>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<CoinBalance>>> get coinsListStream =>
      _coinListController!.stream;

  BalancesBloc(List<CoinBalance>? lc) {
    _coinListController = StreamController<ApiResponse<List<CoinBalance>>>();
    if(lc != null) {
      coinsListSink.add(ApiResponse.completed(lc));
    }
    fetchBalancesList(lc);
  }

  fetchBalancesList(List<CoinBalance>? lc) async {
    if(lc == null)  coinsListSink.add(ApiResponse.loading('Fetching All Coins'));
    try {
      List<CoinBalance>? _coins = await _balanceList.fetchAllBalances();
      if (!_coinListController!.isClosed)
        coinsListSink.add(ApiResponse.completed(_coins));
    } catch (e) {
      if (!_coinListController!.isClosed)
      coinsListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  dispose() {
    _coinListController?.close();
  }
}