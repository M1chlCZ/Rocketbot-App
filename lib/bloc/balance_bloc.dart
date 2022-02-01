import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rocketbot/endpoints/get_all_balances.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/netInterface/api_response.dart';
import 'package:rocketbot/support/globals.dart' as globals;


class BalancesBloc {
  final CoinBalances _balanceList = CoinBalances();
  final _storage = const FlutterSecureStorage();
  List<CoinBalance>? _coins;
  int _sort = 0;

  StreamController<ApiResponse<List<CoinBalance>>>? _coinListController;

  StreamSink<ApiResponse<List<CoinBalance>>> get coinsListSink =>
      _coinListController!.sink;

  Stream<ApiResponse<List<CoinBalance>>> get coinsListStream =>
      _coinListController!.stream;

  BalancesBloc() {
    _coinListController = StreamController<ApiResponse<List<CoinBalance>>>();
    fetchBalancesList();
  }

  fetchBalancesList({int? sort, bool refresh = false}) async {
  coinsListSink.add(ApiResponse.loading('Fetching All Coins'));
    try {
      if(sort == null) {
        var i = await _storage.read(key: globals.SORT_TYPE);
        if(i != null) {
          _sort = int.parse(i);
        }else{
          _sort = 0;
        }
      }else{
        _sort = sort;
      }
      if (!_coinListController!.isClosed) {
        if(refresh) _coins = null;
        _coins ??= await _balanceList.fetchAllBalances();
        List<CoinBalance>? _sortedCoins = await _sortList(_coins, sort: _sort);
        coinsListSink.add(ApiResponse.completed(_sortedCoins));
      }
    } catch (e) {
      print(e);
      if (!_coinListController!.isClosed) {
        coinsListSink.add(ApiResponse.error(e.toString()));
      }
      // print(e);
    }
  }

  Future<List<CoinBalance>> _sortList(List<CoinBalance>? _finalList, {int sort = 0}) async {
    if (sort == 0) {
      _finalList!.sort((a, b) {
        int A = a.coin!.rank!;
        int B = b.coin!.rank!;
        return A.compareTo(B);
      });
    } else if (sort == 1) {
      _finalList!.sort((a, b) {
        var A = a.coin!.cryptoId;
        var B = b.coin!.cryptoId;
        return A.toString().toLowerCase().compareTo(B.toString().toLowerCase());
      });
    } else if (sort == 2) {
      _finalList!.sort((a, b) {
        double A = a.free!;
        double B = b.free!;
        return B.compareTo(A);
      });
    }else if(sort == 3) {
      _finalList!.sort((a, b) {
        double A = a.free! * a.priceData!.prices!.usd!.toDouble();
        double B = b.free! * b.priceData!.prices!.usd!.toDouble();
        return B.compareTo(A);
      });
    }
    return _finalList!;
  }

  dispose() {
    _coinListController?.close();
  }
}