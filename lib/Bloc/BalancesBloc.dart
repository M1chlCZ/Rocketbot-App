import 'dart:async';

import 'package:rocketbot/Endpoints/GetAllBalances.dart';
import 'package:rocketbot/Endpoints/GetAllCoins.dart';
import 'package:rocketbot/Models/BalanceList.dart';
import 'package:rocketbot/Models/Coin.dart';
import 'package:rocketbot/NetInterface/ApiResponse.dart';

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