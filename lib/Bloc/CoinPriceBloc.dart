import 'dart:async';

import 'package:rocketbot/Endpoints/GetAllBalances.dart';
import 'package:rocketbot/Endpoints/GetAllCoins.dart';
import 'package:rocketbot/Endpoints/GetCoinGraph.dart';
import 'package:rocketbot/Models/BalanceList.dart';
import 'package:rocketbot/Models/Coin.dart';
import 'package:rocketbot/Models/CoinGraph.dart';
import 'package:rocketbot/NetInterface/ApiResponse.dart';

class CoinPriceBloc {
  CoinPrices _balanceList = CoinPrices();

  StreamController<ApiResponse<PriceData>>? _coinListController;

  StreamSink<ApiResponse<PriceData>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<PriceData>> get coinsListStream =>
      _coinListController!.stream;

  CoinPriceBloc(String coin) {
    _coinListController = StreamController<ApiResponse<PriceData>>();
    _fetchCoinPriceData(coin);
  }

  changeCoin (String coin) {
    _fetchCoinPriceData(coin);
  }

  _fetchCoinPriceData(String coin) async {
    coinsListSink.add(ApiResponse.loading('Fetching Coin balances'));
    try {
      PriceData? _coins = await _balanceList.fetchCoinPrice(coin);
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