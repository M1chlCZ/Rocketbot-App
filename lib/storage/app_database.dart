import "dart:io" as io;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/pgwid.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sprintf/sprintf.dart';

import 'package:rocketbot/support/globals.dart' as globals;

const dbVersion = 2;

class AppDatabase {
  final String stakeTable = sprintf(
      'CREATE TABLE IF NOT EXISTS %s (%s INTEGER PRIMARY KEY, %s STRING, %s INTEGER, %s INTEGER, %s REAL, %s STRING)',
      [
        globals.TABLE_STAKE,
        globals.TS_ID,
        globals.TS_PWG,
        globals.TS_FINISHED,
        globals.TS_COINID,
        globals.TS_AMOUNT,
        globals.TS_ADDR
      ]);
  final String coinTable = sprintf(
      'CREATE TABLE IF NOT EXISTS %s (%s INTEGER PRIMARY KEY, %s INTEGER, %s STRING, %s STRING, %s STRING, %s INTEGER, %s STRING, %s REAL, %s INTEGER, %s REAL, %s STRING, %s STRING, %s INTEGER, %s STRING, %s INTEGER, %s STRING, %s STRING, %s INTEGER, %s INTEGER)',
      [
        globals.TABLE_COIN,
        globals.TC_ID,
        globals.TC_RANK,
        globals.TC_NAME,
        globals.TC_TICKER,
        globals.TC_CRYPTO_ID,
        globals.TC_IS_TOKEN,
        globals.TC_CONTRACT_ADDR,
        globals.TC_FEE_PERCENT,
        globals.TC_BLOCKCHAIN,
        globals.TC_MIN_WITHDRAW,
        globals.TC_IMAGE_BIG,
        globals.TC_IMAGE_SMALL,
        globals.TC_IS_ACTIVE,
        globals.TC_EXPLORER_URL,
        globals.TC_REQUIRED_CONF,
        globals.TC_FULL_NAME,
        globals.TC_TOKEN_STANDARD,
        globals.TC_ALLOW_WITH,
        globals.TC_ALLOW_DEP
      ]);
  static Database? _db;
  static final AppDatabase _instance = AppDatabase.internal();

  factory AppDatabase() => _instance;
  List<String> tablesSql = [];

  AppDatabase.internal();

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'maindb.db');
    var db = await openDatabase(path,
        version: dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  Future<Database> get db async {
    tablesSql.add(stakeTable);
    tablesSql.add(coinTable);

    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future addTX(
      String txid, int idCoin, double amount, String depositAddress) async {
    final dbClient = await db;
    dynamic tx = {
      globals.TS_PWG: txid,
      globals.TS_FINISHED: 0,
      globals.TS_COINID: idCoin,
      globals.TS_AMOUNT: amount,
      globals.TS_ADDR: depositAddress
    };
    var res = dbClient.insert(globals.TABLE_STAKE, tx);
    return res;
  }

  Future finishTX(String txid) async {
    final dbClient = await db;
    dynamic contact = {
      globals.TS_FINISHED: 1,
    };
    var res = dbClient.update(globals.TABLE_STAKE, contact,
        where: "${globals.TS_PWG} = ?", whereArgs: [txid]);
    return res;
  }

  Future<List<PGWIdentifier>> getUnfinishedTX() async {
    final dbClient = await db;
    var res = await dbClient.query(globals.TABLE_STAKE,
        where: "${globals.TS_FINISHED} = ?", whereArgs: [0]);
    return List.generate(res.length, (i) {
      return PGWIdentifier(
        id: res[i][globals.TS_ID] as int,
        pgw: res[i][globals.TS_PWG] as String,
        txFinish: res[i][globals.TS_FINISHED] as int,
        amount: res[i][globals.TS_AMOUNT] as double,
        depAddr: res[i][globals.TS_ADDR] as String,
        idCoin: res[i][globals.TS_COINID] as int,
      );
    });
  }

  Future<List<Coin>> getCoins() async {
    final dbClient = await db;
    var res = await dbClient.query(globals.TABLE_COIN);
    return List.generate(res.length, (i) {
      return Coin(
        id: res[i][globals.TC_ID] as int,
        rank: res[i][globals.TC_RANK] as int,
        name: res[i][globals.TC_NAME] as String,
        ticker: res[i][globals.TC_TICKER] as String,
        cryptoId: res[i][globals.TC_CRYPTO_ID] as String,
        isToken: res[i][globals.TC_IS_TOKEN] == 0 ? false : true,
        contractAddress: res[i][globals.TC_CONTRACT_ADDR] as String,
        feePercent: res[i][globals.TC_FEE_PERCENT] as double,
        blockchain: res[i][globals.TC_BLOCKCHAIN] as int,
        minWithdraw: res[i][globals.TC_MIN_WITHDRAW] as double,
        imageBig: res[i][globals.TC_IMAGE_BIG] as String,
        imageSmall: res[i][globals.TC_IMAGE_SMALL] as String,
        isActive: res[i][globals.TC_IS_TOKEN] == 0 ? false : true,
        explorerUrl: res[i][globals.TC_EXPLORER_URL] as String,
        requiredConfirmations: res[i][globals.TC_REQUIRED_CONF] as int,
        fullName: res[i][globals.TC_FULL_NAME] as String,
        tokenStandart: res[i][globals.TC_TOKEN_STANDARD] as String,
        allowWithdraws: res[i][globals.TC_ALLOW_WITH] == 0 ? false : true,
        allowDeposits: res[i][globals.TC_ALLOW_DEP] == 0 ? false : true,
      );
    });
  }

  Future<List<Coin>> getCoin(int coinID) async {
    final dbClient = await db;
    var res = await dbClient.query(globals.TABLE_COIN, where: "${globals.TC_ID}= ? ", whereArgs: [coinID]);
    return List.generate(res.length, (i) {
      return Coin(
        id: res[i][globals.TC_ID] as int,
        rank: res[i][globals.TC_RANK] as int,
        name: res[i][globals.TC_NAME] as String,
        ticker: res[i][globals.TC_TICKER] as String,
        cryptoId: res[i][globals.TC_CRYPTO_ID] as String,
        isToken: res[i][globals.TC_IS_TOKEN] == 0 ? false : true,
        contractAddress: res[i][globals.TC_CONTRACT_ADDR] as String,
        feePercent: res[i][globals.TC_FEE_PERCENT] as double,
        blockchain: res[i][globals.TC_BLOCKCHAIN] as int,
        minWithdraw: res[i][globals.TC_MIN_WITHDRAW] as double,
        imageBig: res[i][globals.TC_IMAGE_BIG] as String,
        imageSmall: res[i][globals.TC_IMAGE_SMALL] as String,
        isActive: res[i][globals.TC_IS_TOKEN] == 0 ? false : true,
        explorerUrl: res[i][globals.TC_EXPLORER_URL] as String,
        requiredConfirmations: res[i][globals.TC_REQUIRED_CONF] as int,
        fullName: res[i][globals.TC_FULL_NAME] as String,
        tokenStandart: res[i][globals.TC_TOKEN_STANDARD] as String,
        allowWithdraws: res[i][globals.TC_ALLOW_WITH] == 0 ? false : true,
        allowDeposits: res[i][globals.TC_ALLOW_DEP] == 0 ? false : true,
      );
    });
  }

  Future<void> insertCoin(Coin c) async {
    final dbClient = await db;
    await dbClient.insert(globals.TABLE_COIN, c.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _onCreate(Database db, int version) async {
    for (var element in tablesSql) {
      db.execute(element);
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 1:
        try {
          await db.execute(coinTable);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        break;
    }
  }
}
