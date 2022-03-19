import 'dart:async';

import 'package:rocketbot/endpoints/get_stake_graph.dart';
import 'package:rocketbot/models/stake_data.dart';
import 'package:rocketbot/netInterface/api_response.dart';

class StakeGraphBloc {
  final StakeList _coinsList = StakeList();

  StreamController<ApiResponse<StakingData>>? _coinListController;

  StreamSink<ApiResponse<StakingData>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<StakingData>> get coinsListStream =>
      _coinListController!.stream;

  stakeBloc() {
    _coinListController = StreamController<ApiResponse<StakingData>>();
  }

  fetchStakeData(int coinID, int type) async {
    coinsListSink.add(ApiResponse.loading('Fetching All Stakes'));
    try {
      StakingData? _coins = await _coinsList.getStakingData(coinID, type);
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