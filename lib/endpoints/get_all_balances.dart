import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rocketbot/cache/balances_cache.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/netInterface/interface.dart';

class CoinBalances {
  final _storage = const FlutterSecureStorage();
  final NetInterface _interface = NetInterface();
  PosCoinsList? pl;

  Future<List<CoinBalance>?> fetchAllBalances(bool force) async {
    // print("|FIRST STAKING BEGIN| " + DateTime.now().toString());
    pl = await _getPosCoins();
    if (pl == null) {
      await _registerPos();
      pl = await _getPosCoins();
    }
    // print("|SECOND STAKING DONE| " + DateTime.now().toString());
    List<CoinBalance> _list = await BalanceCache.getAllRecords(forceRefresh: force);
    // print("|THIRD COIN BALANCEs START| " + DateTime.now().toString());
    for (var i = 0; i < _list.length; i++) {
      var coin = _list[i].coin!;
      int index = -1;
      if (pl != null) {
        index = pl!.coins!.indexWhere((element) => element.idCoin == coin.id);
      }
      if (index != -1) {
        _list[i].setStaking(true);
      } else {
        _list[i].setStaking(false);
      }
    }
    // print("|FIFTH COIN BALANCEs DONE| " + DateTime.now().toString());
    return _list;
  }

  _registerPos() async {
    String? _posToken = await _storage.read(key: NetInterface.posToken);
    if (_posToken == null) {
      String? _token = await _storage.read(key: NetInterface.token);
      await NetInterface.registerPos(_token!);
    } else {
      debugPrint(_posToken);
    }
  }

  Future<PosCoinsList?> _getPosCoins() async {
    try {
      var response = await _interface.get("coin/get", pos: true);
      return PosCoinsList.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
