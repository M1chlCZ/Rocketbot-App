import 'dart:async';

import 'package:rocketbot/endpoints/get_all_coins.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/netInterface/api_response.dart';

class CoinsBloc {
  final CoinsList _coinsList = CoinsList();

  StreamController<ApiResponse<List<Coin>>>? _coinListController;

  StreamSink<ApiResponse<List<Coin>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<Coin>>> get coinsListStream =>
      _coinListController!.stream;

  CoinsBloc() {
    _coinListController = StreamController<ApiResponse<List<Coin>>>();
    fetchCoinsList();
  }

  fetchCoinsList() async {
    coinsListSink.add(ApiResponse.loading('Fetching All Coins'));
    try {
      List<Coin>? coins = await _coinsList.fetchAllCoins();
      coinsListSink.add(ApiResponse.completed(coins));
    } catch (e) {
      coinsListSink.add(ApiResponse.error(e.toString()));
      // print(e);
    }
  }

  dispose() {
    _coinListController?.close();
  }
}