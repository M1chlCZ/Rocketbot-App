import 'package:flutter/foundation.dart';
import 'package:rocketbot/cache/balances_cache.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/support/secure_storage.dart';

class CoinBalances {
  final NetInterface _interface = NetInterface();
  PosCoinsList? pl;

  Future<List<CoinBalance>?> fetchAllBalances(bool force) async {
    // print("|FIRST STAKING BEGIN| " + DateTime.now().toString());
    pl = await _getPosCoins();
    String? posToken = await SecureStorage.readStorage(key: NetInterface.posToken);
    if (kDebugMode) {
      print(posToken ?? "NULL TOKEN");
    }
    if (pl == null) {
      await _registerPos();
      pl = await _getPosCoins();
    }
    // print("|SECOND STAKING DONE| " + DateTime.now().toString());
    List<CoinBalance> list = await BalanceCache.getAllRecords(forceRefresh: force);
    // print("|THIRD COIN BALANCEs START| " + DateTime.now().toString());
    for (var i = 0; i < list.length; i++) {
      var coin = list[i].coin!;
      int index = -1;
      if (pl != null) {
        index = pl!.coins!.indexWhere((element) => element.idCoin == coin.id);
      }
      if (index != -1) {
        list[i].setStaking(true);
        list[i].setPosCoin(pl!.coins![index]);
      } else {
        list[i].setStaking(false);
      }
    }
    // print("|FIFTH COIN BALANCEs DONE| " + DateTime.now().toString());
    return list;
  }

  _registerPos() async {
    String? posToken = await SecureStorage.readStorage(key: NetInterface.posToken);
    if (posToken == null) {
      String? token = await SecureStorage.readStorage(key: NetInterface.token);
      await NetInterface.registerPos(token!);
    } else {
      debugPrint(posToken);
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
