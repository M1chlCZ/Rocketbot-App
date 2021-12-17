import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/screenPages/coin_page.dart';
import 'package:rocketbot/screenpages/deposit_page.dart';
import 'package:rocketbot/screenpages/send_page.dart';

import '../component_widgets/button_neu.dart';
import '../screenPages/portfolio_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _portfolioKey = GlobalKey<PortfolioScreenState>();
  final _pageController = PageController(initialPage: 1);
  int _selectedPageIndex = 1;
  List<CoinBalance>? _lc;
  int _mainPageIndex = 0;
  late Coin _coinActive;

  @override
  void initState() {
    super.initState();
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

  void getBalances(List<CoinBalance>? lc) {
    _lc = lc;
  }

  void changeCoinName(Coin? s) {
    _lc = _portfolioKey.currentState!.getList();
    setState(() {
      _mainPageIndex = 1;
      _coinActive = s!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedPageIndex = index;
              });
            },
            children: <Widget>[
              DepositPage(),
              PageTransitionSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (child, animation, secondaryAnimation) =>
                    FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                ),
                child: _mainPageIndex == 0
                    ? PortfolioScreen(
                        key: _portfolioKey, coinSwitch: changeCoinName, listBalances: _lc, passBalances: getBalances)
                    : CoinScreen(
                        activeCoin: _coinActive,
                        allCoins: _lc,
                        goBack: goBack,
                      ),
              ),
              SendPage(listBalances: _lc, passBalances: getBalances),
            ]),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
                  imageIcon: Image.asset(
                    "images/bottommenu1.png",
                    width: 20,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                label: '',
                activeIcon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _onTappedBar(0);
                  },
                  imageIcon: Image.asset(
                    "images/bottommenu1.png",
                    color: Color(0xFF15D37A),
                    width: 20,
                    fit: BoxFit.fitWidth,
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
                  imageIcon: Image.asset(
                    "images/bottommenu2.png",
                    color: Colors.white,
                    width: 20,
                    fit: BoxFit.fitWidth,
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
                  imageIcon: Image.asset(
                    "images/bottommenu2.png",
                    width: 20,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _onTappedBar(2);
                  },
                  imageIcon: Image.asset(
                    "images/bottommenu3.png",
                    width: 20,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                label: '',
                activeIcon: NeuButton(
                  width: 45,
                  height: 45,
                  onTap: () {
                    _onTappedBar(2);
                  },
                  imageIcon: Image.asset(
                    "images/bottommenu3.png",
                    color: Color(0xFFEB3A13),
                    width: 20,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedPageIndex = value;
    });
    _pageController.animateToPage(value,
    duration: Duration(milliseconds: 300), curve: Curves.easeInOutCirc);
    // _pageController.jumpToPage(value);
  }
}
