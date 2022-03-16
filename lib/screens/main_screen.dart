import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/deposit_address.dart';
import 'package:rocketbot/models/pos_coins_list.dart';
import 'package:rocketbot/models/transaction_data.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/screenPages/coin_page.dart';
import 'package:rocketbot/screenpages/deposit_page.dart';
import 'package:rocketbot/screenpages/send_page.dart';
import 'package:rocketbot/screenpages/staking_page.dart';
import 'package:rocketbot/support/notification_helper.dart';

import '../component_widgets/button_neu.dart';
import '../screens/portfolio_page.dart';

class MainScreen extends StatefulWidget {
  final CoinBalance coinBalance;
  final List<CoinBalance>? listCoins;
  final PosCoinsList? posCoinsList;
  final VoidCallback refreshList;



  const MainScreen(
      {Key? key,
      required this.coinBalance,
      this.listCoins,
      this.posCoinsList,
      required this.refreshList,})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NetInterface _interface = NetInterface();
  final _portfolioKey = GlobalKey<PortfolioScreenState>();
  final _pageController = PageController(initialPage: 1);
  String? _depositAddr;
  String? _posDepositAddr;
  int _selectedPageIndex = 1;
  List<CoinBalance>? _lc;
  int _mainPageIndex = 0;
  late Coin _coinActive;
  double _free = 0.0;
  bool _swipeBlock = false;
  bool _posCoin = false;

  @override
  void initState() {
    super.initState();
    _coinActive = widget.coinBalance.coin!;
    _free = widget.coinBalance.free!;
    _lc = widget.listCoins!;
    _checkPosCoin(_coinActive);
    _getDepositAddr();
    // _bloc = BalancesBloc();
    // _priceBlock = CoinPriceBloc("merge");
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _bloc!.dispose();
    // _priceBlock!.dispose();
    super.dispose();
  }

  void goBack() {
    setState(() {
      _mainPageIndex = 0;
    });
  }

  void _checkPosCoin(Coin? c) {
    try {
      final indexPos = widget.posCoinsList!.coins!
          .indexWhere((element) => element.idCoin! == c?.id!);
      indexPos != -1 ? _posCoin = true : _posCoin = false;
      if (indexPos != -1) {
        _posDepositAddr = widget.posCoinsList!.coins![indexPos].depositAddr!;
      } else {
        _posDepositAddr = null;
      }
      setState(() {});
    }catch(e){
      _posDepositAddr = null;
      debugPrint(e.toString());
    }
  }

  void _setActiveCoin(Coin? c) {
    final index = _lc!.indexWhere((element) => element.coin == c);
    _free = _lc![index].free!;
    _coinActive = c!;
    _checkPosCoin(_coinActive);
    _getDepositAddr();
    setState(() {});
  }

  void getBalances(List<CoinBalance>? lc) {
    _lc = lc;
  }

  void _changeFree(double free) {
    _free = free;
    widget.refreshList();
  }

  void changeCoinName(Coin? s) {
    _lc = _portfolioKey.currentState!.getList();
    setState(() {
      _mainPageIndex = 1;
      _coinActive = s!;
    });
  }

  _getDepositAddr() async {
    Map<String, dynamic> _request = {
      "coinId": _coinActive.id!,
    };
    try {
      final response =
          await _interface.post("Transfers/CreateDepositAddress", _request);
      var d = DepositAddress.fromJson(response);
      setState(() {
        _depositAddr = d.data!.address!;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            children: <Widget>[
              DepositPage(
                coin: _coinActive,
                free: _free,
                depositAddr: _depositAddr,
              ),
              CoinScreen(
                  setActiveCoin: _setActiveCoin,
                  activeCoin: _coinActive,
                  allCoins: _lc,
                  goBack: goBack,
                  blockTouch: _blockTouch,
                  free: _free),
              StakingPage(
                setActiveCoin: _setActiveCoin,
                changeFree: _changeFree,
                depositAddress: _depositAddr,
                depositPosAddress: _posDepositAddr,
                activeCoin: _coinActive,
                allCoins: _lc,
                free: _free,
                goBack: goBack,
                blockTouch: _blockTouch,
              ),
              SendPage(
                changeFree: _changeFree,
                coinActive: _coinActive,
                free: _free,
              ),
            ]),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white30, width: 0.5)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            elevation: 10.0,
            onTap: _onTappedBar,
            currentIndex: _selectedPageIndex,
            fixedColor: const Color(0xFF1B1B1B),
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _onTappedBar(0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Image.asset(
                      "images/receive_nav_icon.png",
                      width: 25,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                label: '',
                activeIcon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _onTappedBar(0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Image.asset(
                      "images/receive_nav_icon.png",
                      color: const Color(0xFF15D37A),
                      width: 25,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _mainPageIndex = 0;
                    _onTappedBar(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Image.asset(
                      "images/coin_nav_icon.png",
                      color: Colors.white,
                      width: 34,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                label: '',
                activeIcon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _mainPageIndex = 0;
                    _onTappedBar(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Image.asset(
                      "images/coin_nav_icon.png",
                      width: 34,
                      fit: BoxFit.fitWidth,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    if (_posCoin) {
                      _onTappedBar(2);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Image.asset(
                      "images/staking_icon.png",
                      width: 38,
                      fit: BoxFit.fitWidth,
                      color: _posCoin ? Colors.white : Colors.white30,
                    ),
                  ),
                ),
                label: '',
                activeIcon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    if (_posCoin) {
                      _onTappedBar(2);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Image.asset(
                      "images/staking_icon.png",
                      color: const Color(0xFFFDCB29),
                      width: 38,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _onTappedBar(3);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Image.asset(
                      "images/send_nav_icon.png",
                      width: 25,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                label: '',
                activeIcon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _onTappedBar(3);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Image.asset(
                      "images/send_nav_icon.png",
                      color: const Color(0xFFEB3A13),
                      width: 25,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _blockTouch(bool b) {
    setState(() {
      _swipeBlock = !b;
    });
  }

  void _onTappedBar(int value) {
    if(value == 2 && _posCoin == false) {
      return;
    }
    setState(() {
      _selectedPageIndex = value;
    });
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCirc);
    // _pageController.jumpToPage(value);
  }
}
