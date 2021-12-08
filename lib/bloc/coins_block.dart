import 'dart:async';

import 'package:rocketbot/Endpoints/get_all_coins.dart';
import 'package:rocketbot/Models/coin.dart';
import 'package:rocketbot/NetInterface/api_response.dart';

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
      List<Coin>? _coins = await _coinsList.fetchAllCoins();
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