import 'dart:async';

import 'package:rocketbot/endpoints/get_coin_graph.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/netInterface/api_response.dart';

class CoinPriceBloc {
  final CoinPrices _balanceList = CoinPrices();

  StreamController<ApiResponse<PriceData>>? _coinListController;

  StreamSink<ApiResponse<PriceData>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<PriceData>> get coinsListStream =>
      _coinListController!.stream;

  CoinPriceBloc(String coin, int coinID) {
    _coinListController = StreamController<ApiResponse<PriceData>>();
    _fetchCoinPriceData(coin, coinID);
  }

  changeCoin (String coin, int coinID) {
    _fetchCoinPriceData(coin, coinID);
  }

  _fetchCoinPriceData(String coin, int coinID) async {
    if (!_coinListController!.isClosed) {
      coinsListSink.add(ApiResponse.loading('Fetching Coin balances'));
    }
    try {
      PriceData? _coins = await _balanceList.fetchCoinPrice(coin, coinID);
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