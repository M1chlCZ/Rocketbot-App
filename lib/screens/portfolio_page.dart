import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/bloc/balance_bloc.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/netInterface/api_response.dart';
import 'package:rocketbot/screens/about_screen.dart';
import 'package:rocketbot/screens/main_screen.dart';
import 'package:rocketbot/screens/settings_screen.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import '../support/notification_helper.dart';
import '../widgets/coin_list_view.dart';
import 'package:rocketbot/support/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PortfolioScreen extends StatefulWidget {


  const PortfolioScreen({
    Key? key,
  }) : super(key: key);

  @override
  PortfolioScreenState createState() => PortfolioScreenState();
}

class PortfolioScreenState extends LifecycleWatcherState<PortfolioScreen> {
  final _storage = const FlutterSecureStorage();
  final ScrollController _scrollController = ScrollController();
  BalancesBloc? _bloc;
  List<CoinBalance>? _listCoins;
  final _firebaseMessaging = FCM();

  double totalUSD = 0.0;
  double totalBTC = 0.0;

  bool portCalc = false;
  bool popMenu = false;
  bool _paused = false;
  bool _pinEnabled = false;
  bool _hideZero = false;

  double _listHeight = 0.0;

  var _dropValue = "Default";
  var _dropValues = ["Default", "By amount", "Alphabetically"];

  @override
  void initState() {
    super.initState();
    _initializeLocalNotifications();
    _firebaseMessaging.setNotifications();
    _scrollController.addListener(() {
      if(popMenu) {
        setState(() {popMenu = false;});
      }
    });
    _fillSort();
    _bloc = BalancesBloc();
    // portCalc = widget.listBalances != null ? true : false;
  }

  void _fillSort()  {
    Future.delayed(Duration.zero, () async {
    _dropValue = AppLocalizations.of(context)!.deflt;
    _dropValues.clear();
    _dropValues = [AppLocalizations.of(context)!.deflt,AppLocalizations.of(context)!.alphabeticall, AppLocalizations.of(context)!.by_amount, AppLocalizations.of(context)!.by_value];
    var i = await _storage.read(key: globals.SORT_TYPE);
    if(i == null) {
      _dropValue = _dropValues[0];
    }else{
      _dropValue = _dropValues[int.parse(i)];
    }
      setState(() {});
    });

  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }

  Matrix4 scaleXYZTransform({
    double scaleX = 1.05,
    double scaleY = 1.00,
    double scaleZ = 0.00,
  }) {
    return Matrix4.diagonal3Values(scaleX, scaleY, scaleZ);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<CoinBalance> getList() {
    return _listCoins!;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: const Color(0xFFCB1668),
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: _listHeight == 0.0 ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height * 0.3 + _listHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 0.0),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.portfolio,
                                style: Theme.of(context).textTheme.headline4),
                            const SizedBox(
                              width: 50,
                            ),
                            // SizedBox(
                            //     height: 30,
                            //     child: TimeRangeSwitcher(
                            //       changeTime: _changeTime,
                            //     )),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 25,
                                    child: NeuButton(
                                      onTap: () async {
                                        setState(() {
                                          if (popMenu) {
                                            popMenu = false;
                                          } else {
                                            popMenu = true;
                                          }
                                        });
                                        // await const FlutterSecureStorage().delete(key: "token");
                                        // Navigator.of(context).pushReplacement(
                                        //     PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                                        //       return const LoginScreen();
                                        //     }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                        //       return FadeTransition(opacity: animation, child: child);
                                        //     }));
                                      },
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: portCalc
                            ? Stack(
                                // alignment: AlignmentDirectional.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 10.0, top: 50.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Transform(
                                        transform: scaleXYZTransform(),
                                        child: const Image(
                                          fit: BoxFit.fitWidth,
                                          image: AssetImage("images/wave.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 170.0, right: 0.0, top: 90.0),
                                    child: Transform.scale(
                                      scale: 0.35,
                                      child: const Image(
                                        image: AssetImage("images/rocket_pin.png"),
                                      ),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 98.0),
                                      child: AspectRatio(
                                        aspectRatio: 1.6,
                                        child: Image(
                                            fit: BoxFit.fitWidth,
                                            image:
                                                AssetImage("images/price_frame.png")),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 130.0, top: 25.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: AutoSizeText(
                                              "\$" + totalUSD.toStringAsFixed(2),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1,
                                              minFontSize: 8.0,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          SizedBox(
                                            width: 130,
                                            child: AutoSizeText(
                                              _formatPrice(totalBTC) + " BTC",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2,
                                              minFontSize: 8.0,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                      const SizedBox(height: 5.0,),
                      SizedBox(
                        height: 25.0,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 3.0),
                            child: Opacity(
                              opacity: 0.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 0.0),
                                    child: Icon(Icons.sort, color: Colors.white30, size: 10.0,),
                                  ),
                                  // Text('sort by:', style: Theme.of(context).textTheme.headline2!.copyWith( fontSize: 14.0, color: Colors.white30)),
                                  const SizedBox(width: 5.0,),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _dropValue,
                                      isDense: true,
                                      onChanged: (String? val) async {
                                        var _tempZero = _hideZero;
                                        setState(() {
                                          _hideZero = false;
                                          _dropValue = val!;
                                          _listCoins = null;
                                        });
                                        int sort = _dropValues.indexWhere((element) => element == _dropValue);
                                       await _storage.write(key: globals.SORT_TYPE, value: sort.toString());
                                        await _bloc!.fetchBalancesList(sort: sort);
                                        _hideZero = _tempZero;
                                        await _checkZero();

                                      },
                                      items: _dropValues
                                          .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: SizedBox(
                                              width: 130,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 2.0),
                                                child: Text(e, style: Theme.of(context).textTheme.headline2!.copyWith( fontSize: 11.0, color: Colors.white70)),
                                              ))))
                                          .toList(),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0, right: 8.0, top:1.0),
                                      child: SizedBox(
                                        height: 0.5,
                                        child: Container(
                                          color: portCalc ? Colors.white12 : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0,),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(bottom: 1.0),
                                  //   child: FlatCustomButton(
                                  //     onTap: () {
                              // _listCoins = null;
                                  //       setState(() {
                                  //         if(_hideZero) {
                                  //           _hideZero = false;
                                  //           _bloc!.fetchBalancesList();
                                  //           // _bloc!.filterCoinsList(zero: _hideZero);
                                  //         }else{
                                  //           _hideZero = true;
                                  //           _bloc!.filterCoinsList(zero: _hideZero);
                                  //           // _bloc!.filterCoinsList(zero: _hideZero);
                                  //         }
                                  //       });
                                  //     },
                                  //       child:
                                  //       Padding(
                                  //         padding: const EdgeInsets.only(left: 0.0, right: 1.0),
                                  //         child: FittedBox(
                                  //           child: AutoSizeText(AppLocalizations.of(context)!.hide_zeros, style: Theme.of(context).textTheme.headline2!.copyWith( fontSize: 11.0, color:_hideZero ?  Colors.white : Colors.white30),
                                  //           )
                                  //   ),
                                  //       ),
                                  // ),
                                  //
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 1.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _listCoins = null;
                                            if(_hideZero) {
                                              _hideZero = false;
                                              _bloc!.fetchBalancesList();
                                              // _bloc!.filterCoinsList(zero: _hideZero);
                                            }else{
                                              _hideZero = true;
                                              _bloc!.filterCoinsList(zero: _hideZero);
                                              // _bloc!.filterCoinsList(zero: _hideZero);
                                            }
                                          });

                                        },
                                        child:
                                        AutoSizeText(AppLocalizations.of(context)!.hide_zeros, style: Theme.of(context).textTheme.headline2!.copyWith( fontSize: 11.0, color:_hideZero ?  Colors.white : Colors.white30),
                                    ),
                                  ),
                                  ),
                                  const SizedBox(width: 8.0,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: StreamBuilder<ApiResponse<List<CoinBalance>>>(
                            stream: _bloc!.coinsListStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                switch (snapshot.data!.status) {
                                  case Status.LOADING:
                                    _listCoins = null;
                                    return Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 40.0),
                                        child: HeartbeatProgressIndicator(
                                          startScale: 0.01,
                                          endScale: 0.2,
                                          child: const Image(
                                            image: AssetImage('images/rocketbot_logo.png'),
                                            color: Colors.white30,
                                          ),
                                        ),
                                      ),
                                    );
                                  case Status.COMPLETED:
                                    if (_listCoins == null) {
                                      _listCoins = snapshot.data!.data!;
                                      _listHeight = _hideZero ?_listCoins!.length * 80.0 : _listCoins!.length * 69.0;
                                      // widget.passBalances(listCoins);
                                      _calculatePortfolio();
                                    }
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.data!.length,
                                        itemBuilder: (ctx, index) {
                                          return CoinListView(
                                            key: ValueKey(snapshot.data!.data![index].coin!.id!),
                                            coin: snapshot.data!.data![index],
                                            free: Decimal.parse(snapshot.data!.data![index].free.toString()),
                                            coinSwitch: _changeCoin,
                                          );
                                        });
                                  case Status.ERROR:
                                    print("error");
                                    break;
                                }
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
                visible: false,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        popMenu = false;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      color: Colors.transparent,
                      width: double.infinity,
                      height: double.infinity,
                    ))),
            Positioned(
                top: 40.0,
                right: 4.0,
                child: AnimatedOpacity(
                  opacity: popMenu ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  child: Card(
                    elevation: 10.0,
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      child: Container(
                        width: 120,
                        color: const Color(0xFF1B1B1B),
                        child: Column(
                          children: [
                            SizedBox(
                              // SizedBox(
                                height: 40,
                                child: Center(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: 140,
                                      child: TextButton(
                                        child: Text(
                                          AppLocalizations.of(context)!.settings_popup,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(fontSize: 14.0),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                    (states) =>
                                                    qrColors(states)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        0.0),
                                                    side: const BorderSide(
                                                        color: Colors
                                                            .transparent)))),
                                        onPressed: () {
                                            setState(() {popMenu = false;});
                                          Navigator.of(context).push(PageRouteBuilder(
                                              pageBuilder: (BuildContext context, _, __) {
                                                return const SettingsScreen();
                                              }, transitionsBuilder:
                                              (_, Animation<double> animation, __, Widget child) {
                                            return FadeTransition(opacity: animation, child: child);
                                          })).then((value) => _fillSort());
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Container(
                                height: 0.5,
                                color: Colors.white12,
                              ),
                            ),
                            SizedBox(
                              // SizedBox(
                                height: 40,
                                child: Center(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: 140,
                                      child: TextButton(
                                        child: Text(
                                          AppLocalizations.of(context)!.about_popup,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(fontSize: 14.0),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                    (states) =>
                                                    qrColors(states)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        0.0),
                                                    side: const BorderSide(
                                                        color: Colors
                                                            .transparent)))),
                                        onPressed: () {
                                          setState(() {popMenu = false;});
                                          Navigator.of(context).push(PageRouteBuilder(
                                              pageBuilder: (BuildContext context, _, __) {
                                                return const AboutScreen();
                                              }, transitionsBuilder:
                                              (_, Animation<double> animation, __, Widget child) {
                                            return FadeTransition(opacity: animation, child: child);
                                          }));
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            Visibility(
              visible: !portCalc,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                color: const Color(0xFF1B1B1B),
                child: Center(
                  child: HeartbeatProgressIndicator(
                    startScale: 0.01,
                    endScale: 0.2,
                    child: const Image(
                      image: AssetImage('images/rocketbot_logo.png'),
                      color: Colors.white30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _refreshData() async {
    await _bloc!.fetchBalancesList(refresh: true);
    _listCoins = null;
    setState(() {});
  }

  _changeCoin(CoinBalance c) {
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return MainScreen(
        coinBalance: c,
        listCoins: _listCoins,
      );
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }

  String _formatPrice(double d) {
    var _split = d.toString().split('.');
    var _decimal = _split[1];
    if(_decimal.length >= 8) {
      var _sub = _decimal.substring(0, 7);
      return _split[0] + "." + _sub;
    }else{
      return d.toString();
    }
  }

  _calculatePortfolio() {
    try {
      totalUSD = 0;
      totalBTC = 0;
      for (var element in _listCoins!) {
            double? _freeCoins = element.free;
            double? _priceUSD = element.priceData?.prices?.usd!.toDouble();
            double? _priceBTC = element.priceData?.prices?.btc!.toDouble();
            if(_priceUSD != null && _priceBTC != null) {
              double _usd = _freeCoins! * _priceUSD;
              totalUSD += _usd;
              double _btc = _freeCoins * _priceBTC;
              totalBTC += _btc;
            }
          }

      Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              portCalc = true;
            });
          });
    } catch (e) {
      print(e);
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          portCalc = true;
        });
      });
    }
  }
  Color qrColors(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white30;
    }
    return const Color(0xFF1B1B1A);
  }

  Future _getPinFuture() async {
    var s = _storage.read(key: "PIN");
    return s;
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    Dialogs.openAlertBox(context, "Alert", payload!);
  }

  void _onSelectNotification(String? payload) {
    Dialogs.openAlertBox(context, "Alert", payload!);
  }

  Future <void> _getPin() async {
    final String? pin = await _getPinFuture();
    if (pin != null) _pinEnabled = true;
  }

  void _restartApp() async {
    Phoenix.rebirth(context);
  }

  @override
  void onDetached() {
    _paused = true;
  }

  @override
  void onInactive() {
  }

  @override
  void onPaused() async {
    if (!_paused) {
      var _endTime = DateTime.now().millisecondsSinceEpoch + (1000 * 60);
      await _storage.write(key: globals.COUNTDOWN, value: _endTime.toString());
      _paused = true;
    }
  }

  @override
  void onResumed() async {
    await _getPin();
    if (_pinEnabled == true && _paused) {
      _paused = false;
      var restart = await _checkCountdown();
      if (restart) {
        _restartApp();
      }
    }
  }

  Future<bool> _checkCountdown() async {
    var _countDown = await _storage.read(key: globals.COUNTDOWN);
    if (_countDown != null) {
      int nowDate = DateTime.now().millisecondsSinceEpoch;
      int countTime = int.parse(_countDown);
      if (nowDate > countTime) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  void _initializeLocalNotifications() async {
    if (Platform.isAndroid) {
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'rocket1', // id
        'Rocket 1 stuff', // title
        description: 'This channel is used for transaction notifications.',
        // description
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        ledColor: Colors.red,
      );

      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(channel);

      AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
        'rocket2', // id
        'Rocket 2 stuff', // title
        description: 'This channel is used for message notifications.',
        // description
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        ledColor: Colors.red,
      );

      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.createNotificationChannel(channel2);
    }
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_notification');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  }

  _checkZero() async{
    if(_hideZero == false) return;
    Future.delayed(Duration.zero, (){
    _bloc!.filterCoinsList(zero: _hideZero);
    });
  }
}
