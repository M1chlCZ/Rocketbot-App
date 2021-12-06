import 'dart:async';

import 'package:rocketbot/Endpoints/get_all_balances.dart';
import 'package:rocketbot/Models/balance_list.dart';
import 'package:rocketbot/NetInterface/api_response.dart';

class BalancesBloc {
  CoinBalances _balanceList = CoinBalances();

  StreamController<ApiResponse<List<CoinBalance>>>? _coinListController;

  StreamSink<ApiResponse<List<CoinBalance>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<CoinBalance>>> get coinsListStream =>
      _coinListController!.stream;

  BalancesBloc() {
    _coinListController = StreamController<ApiResponse<List<CoinBalance>>>();
    fetchBalancesList();
  }

  fetchBalancesList() async {
    coinsListSink.add(ApiResponse.loading('Fetching All Coins'));
    try {
      List<CoinBalance>? _coins = await _balanceList.fetchAllBalances();
      coinsListSink.add(ApiResponse.completed(_coins));
    } catch (e) {
      coinsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _coinListController?.close();
  }
}