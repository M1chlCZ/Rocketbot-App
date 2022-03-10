import 'dart:io' show Platform;
import "dart:io" as io;


import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocketbot/models/pgwid.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sprintf/sprintf.dart';

import 'package:rocketbot/support/globals.dart' as globals;



const dbVersion = 1;
class AppDatabase {
  final String stakeTable = sprintf('CREATE TABLE IF NOT EXISTS %s (%s INTEGER PRIMARY KEY, %s STRING, %s INTEGER, %s INTEGER, %s REAL, %s STRING)', [globals.TABLE_STAKE, globals.TS_ID, globals.TS_PWG, globals.TS_FINISHED, globals.TS_COINID, globals.TS_AMOUNT, globals.TS_ADDR]);

  static Database? _db;
  static final AppDatabase _instance = AppDatabase.internal();

  factory AppDatabase() => _instance;
  List<String> tablesSql = [];

  AppDatabase.internal();



  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'maindb.db');
    var db = await openDatabase(
        path, version: dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  Future<Database> get db async {
    tablesSql.add(stakeTable);

    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future addTX(String txid, int idCoin, double amount, String depositAddress) async {
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
    var res = dbClient.update(globals.TABLE_STAKE, contact, where: globals.TS_PWG + " = ?", whereArgs: [txid]);
    return res;
  }

  Future<List<PGWIdentifier>> getUnfinishedTX() async {
    final dbClient = await db;
    var res = await dbClient.query(globals.TABLE_STAKE, where: globals.TS_FINISHED +" = ?", whereArgs: [0]);
    return List.generate(res.length, (i)  {
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



  void _onCreate(Database db, int version) async {
    for (var element in tablesSql) {
      db.execute(element);
    }
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {

    }
  }

}