import 'dart:async';

import 'package:rocketbot/Endpoints/get_coin_graph.dart';
import 'package:rocketbot/Models/coin_graph.dart';
import 'package:rocketbot/NetInterface/api_response.dart';

class CoinPriceBloc {
  final CoinPrices _balanceList = CoinPrices();

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
      // print(e);
    }
  }

  dispose() {
    _coinListController?.close();
  }
}