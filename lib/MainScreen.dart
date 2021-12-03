import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'ComponentWidgets/nButton.dart';
import 'ScreenPages/portfolio_screen.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final pages = [
    PortfolioScreen(),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageTransitionSwitcher(
          duration: Duration(seconds: 1),
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: pages[index],
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
