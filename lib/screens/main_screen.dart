import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/models/balance_list.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/screenPages/coin_screen.dart';

import '../component_widgets/button_neu.dart';
import '../screenPages/portfolio_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _portfolioKey = GlobalKey<PortfolioScreenState>();
  late List<CoinBalance> lc;
  int index = 0;
  late Coin _coinActive;

  @override
  void initState() {
    super.initState();
    // _bloc = BalancesBloc();
    // _priceBlock = CoinPriceBloc("merge");
  }

  @override
  void dispose() {
    // _bloc!.dispose();
    // _priceBlock!.dispose();
    super.dispose();
  }

  void goBack() {
    setState(() {
      index = 0;
    });
  }

  void changeCoinName(Coin? s) {
    lc = _portfolioKey.currentState!.getList();
    setState(() {
      index = 1;
      _coinActive = s!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: index == 0
              ? PortfolioScreen(key: _portfolioKey, coinSwitch: changeCoinName)
              : CoinScreen(
                  activeCoin: _coinActive,
                  allCoins: lc,
                  goBack: goBack,
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu1.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu1.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu2.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu2.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu3.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu3.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
