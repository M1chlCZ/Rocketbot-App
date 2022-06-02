import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/bloc/stake_graph_bloc.dart';
import 'package:rocketbot/models/pgwid.dart';
import 'package:rocketbot/models/stake_data.dart';
import 'package:rocketbot/netInterface/api_response.dart';
import 'package:rocketbot/models/balance_portfolio.dart';
import 'package:rocketbot/models/fees.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/stake_check.dart';
import 'package:rocketbot/models/withdraw_confirm.dart';
import 'package:rocketbot/models/withdraw_pwid.dart';
import 'package:rocketbot/netInterface/app_exception.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/screens/keyboard_overlay.dart';
import 'package:rocketbot/storage/app_database.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/percent_switch_widget.dart';
import 'package:rocketbot/widgets/stake_graph.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../component_widgets/button_neu.dart';
import '../models/balance_list.dart';
import '../models/coin.dart';
import '../models/stake_data.dart';
import '../support/auto_size_text_field.dart';
import '../widgets/coin_price_graph.dart';
import '../widgets/time_stake_range_switch.dart';

class StakingPage extends StatefulWidget {
  final Coin activeCoin;
  final CoinBalance coinBalance;
  final String? depositAddress;
  final String? depositPosAddress;
  final Function(double free) changeFree;
  final VoidCallback goBack;
  final List<CoinBalance>? allCoins;
  final Function(Coin? c) setActiveCoin;
  final Function(bool touch) blockTouch;
  final double free;

  const StakingPage({
    Key? key,
    required this.activeCoin,
    required this.coinBalance,
    required this.changeFree,
    this.depositAddress,
    this.depositPosAddress,
    this.allCoins,
    required this.free,
    required this.goBack,
    required this.setActiveCoin,
    required this.blockTouch,
  }) : super(key: key);

  @override
  StakingPageState createState() => StakingPageState();
}

class StakingPageState extends LifecycleWatcherState<StakingPage> {
  // final _storage = const FlutterSecureStorage();
  final NetInterface _interface = NetInterface();
  final _graphKey = GlobalKey<CoinPriceGraphState>();
  final _percentageKey = GlobalKey<PercentSwitchWidgetState>();
  final GlobalKey<SlideActionState> _keyStake = GlobalKey();
  final TextEditingController _amountController = TextEditingController();
  FocusNode numberFocusNode = FocusNode();
  AnimationController? _animationController;
  Animation<double>? _animation;
  StakeGraphBloc? _stakeBloc;
  late Coin _coinActive;

  bool _staking = false;
  bool _loadingReward = false;
  bool _loadingCoins = false;
  bool _paused = false;
  bool _detailsExtended = false;

  String _amountStaked = "0.0";
  double _unconfirmedAmount = 0.0;
  String _amountReward = "0.0";
  double _estimated = 0.0;
  double _percentage = 0.0;
  double _inPoolTotal = 0.0;
  double _price = 0.0;
  double _free = 0.0;

  double? _fee;
  double? _min;
  int _typeGraph = 0;

  @override
  void initState() {
    super.initState();
    _price = widget.coinBalance.priceData!.prices!.usd!.toDouble();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController!, curve: Curves.fastLinearToSlowEaseIn));
    _coinActive = widget.activeCoin;
    _free = widget.free;
    _amountController.addListener(() {
      _percentageKey.currentState!.deActivate();
    });
    _stakeBloc = StakeGraphBloc();
    _stakeBloc!.stakeBloc();
    _getPos();
    _getFees();
   _getFocusIOS();
  }

  @override
  void dispose() {
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _getPos() {
    _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
    _getStakingDetails();
  }

  Future<void> _getStakingDetails() async {
    Map<String, dynamic> m = {
      "idCoin": _coinActive.id!,
      // "idCoin": 0
    };
    var res = await _interface.post("stake/check", m, pos: true);
    StakeCheck? sc = StakeCheck.fromJson(res);
    if (sc.hasError == true) return;
    if (sc.active == 0) {
      _staking = false;
      _inPoolTotal = sc.inPoolTotal ?? 0.0;
      setState(() {});
    } else {
      _estimated = sc.estimated ?? 0.0;
      _percentage = sc.contribution ?? 0.0;
      _inPoolTotal = sc.inPoolTotal ?? 0.0;
      _amountStaked = sc.amount!.toString();
      _unconfirmedAmount = sc.unconfirmed!;
      _amountReward = _formatDecimal(Decimal.parse(sc.stakesAmount.toString()));
      _staking = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 25,
                      child: NeuButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20.0,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(AppLocalizations.of(context)!.stake_label, style: Theme.of(context).textTheme.headline4),
                    // SizedBox(
                    //   height: 30,
                    //   child: NeuContainer(
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: Center(
                    //           child: DropdownButtonHideUnderline(
                    //             child: DropdownButton<String>(
                    //               value: _menuOptions[0],
                    //               isDense: true,
                    //               onChanged: (String? coin) {
                    //                 setState(() {
                    //                   if (_stakingUI) {
                    //                     _stakingUI = false;
                    //                   }else{
                    //                     _stakingUI = true;
                    //                   }
                    //                 });
                    //               },
                    //               items: _menuOptions.map((String value) {
                    //           return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(value, style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12, color: Colors.white),),
                    //
                    //           );
                    //               }).toList(),
                    //             ),
                    //           ),
                    //         ),
                    //       )),
                    // ),
                    const SizedBox(
                      width: 70,
                    ),
                    SizedBox(
                        height: 30,
                        child: StakeTimeRangeSwitcher(
                          changeTime: _changeTime,
                        )),
                  ],
                ),
              ),
              Stack(
                children: [
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 13.0, left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GradientText(
                            "|STAKING \n|EARLY \n|ACCESS",
                            gradient: LinearGradient(colors: [
                              Colors.white54,
                              Colors.white10.withOpacity(0.0),
                            ]),
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 48.0, color: Colors.white12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: RefreshIndicator(
                      onRefresh: () => _stakeBloc!.fetchStakeData(_coinActive.id!, 0),
                      child: StreamBuilder<ApiResponse<StakingData>>(
                          stream: _stakeBloc!.coinsListStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data!.status) {
                                case Status.completed:
                                  return CoinStakeGraph(
                                    key: _graphKey,
                                    stake: snapshot.data?.data,
                                    activeCoin: _coinActive,
                                    type: _typeGraph,
                                    blockTouch: _blockSwipe,
                                  );
                                case Status.loading:
                                  return Center(
                                    child: HeartbeatProgressIndicator(
                                      startScale: 0.01,
                                      endScale: 0.4,
                                      child: const Image(
                                        image: AssetImage('images/rocketbot_logo.png'),
                                        color: Colors.white30,
                                      ),
                                    ),
                                  );
                                case Status.error:
                                  return Container(
                                    color: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.graph_no_data,
                                          style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  );
                                default:
                                  return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white30, width: 0.5)),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: GradientText(
                    _coinActive.cryptoId!,
                    gradient: const LinearGradient(colors: [
                      Colors.white70,
                      Colors.white54,
                    ]),
                    // textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24.0, color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0, bottom: 8.0),
                  child: GradientText(
                    "EARN NOW",
                    gradient: const LinearGradient(colors: [
                      Colors.white70,
                      Colors.white54,
                    ]),
                    // textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white30, width: 0.5)),
                ),
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Row(
                                children: [
                                  GradientText(
                                    "${AppLocalizations.of(context)!.stake_available}:",
                                    gradient: const LinearGradient(colors: [
                                      Colors.white70,
                                      Colors.white54,
                                    ]),
                                    // textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, color: Colors.white70),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                      child: AutoSizeText(
                                        "$_free ${_coinActive.cryptoId!}",
                                        maxLines: 1,
                                        minFontSize: 8.0,
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Row(
                                children: [
                                  GradientText(
                                    "${AppLocalizations.of(context)!.stake_staked_amount}:",
                                    gradient: const LinearGradient(colors: [
                                      Colors.white70,
                                      Colors.white54,
                                    ]),
                                    // textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, color: Colors.white70),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                      child: AutoSizeText(
                                        "${_formatPriceString(_amountStaked)} ${_coinActive.cryptoId!}",
                                        maxLines: 1,
                                        minFontSize: 8.0,
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _unconfirmedAmount != 0.0
                              ? Opacity(
                                  opacity: 0.6,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          GradientText(
                                            "${AppLocalizations.of(context)!.stake_unconfirmed}:",
                                            gradient: const LinearGradient(colors: [
                                              Colors.white70,
                                              Colors.white54,
                                            ]),
                                            // textAlign: TextAlign.end,
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                              child: AutoSizeText(
                                                "${_unconfirmedAmount.toStringAsFixed(3)} ${_coinActive.cryptoId!}",
                                                maxLines: 1,
                                                minFontSize: 8.0,
                                                textAlign: TextAlign.end,
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Row(
                                children: [
                                  GradientText(
                                    "${AppLocalizations.of(context)!.stake_reward}:",
                                    gradient: const LinearGradient(colors: [
                                      Colors.white70,
                                      Colors.white54,
                                    ]),
                                    // textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, color: Colors.white70),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                      child: AutoSizeText(
                                        "$_amountReward ${_coinActive.cryptoId!}",
                                        maxLines: 1,
                                        minFontSize: 8.0,
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18.0, color: Colors.white70),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                            ),
                          ),
                          SizeTransition(
                            sizeFactor: _animation!,
                            child: Container(
                              color: Colors.black12,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          GradientText(
                                            "${AppLocalizations.of(context)!.staking_total_tokens}:",
                                            gradient: const LinearGradient(colors: [
                                              Colors.white70,
                                              Colors.white54,
                                            ]),
                                            // textAlign: TextAlign.end,
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                              child: AutoSizeText(
                                                "${_inPoolTotal.toStringAsFixed(1)} ${_coinActive.cryptoId!}",
                                                maxLines: 1,
                                                minFontSize: 8.0,
                                                textAlign: TextAlign.end,
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          GradientText(
                                            "${AppLocalizations.of(context)!.staking_monetary_value}:",
                                            gradient: const LinearGradient(colors: [
                                              Colors.white70,
                                              Colors.white54,
                                            ]),
                                            // textAlign: TextAlign.end,
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                              child: AutoSizeText(
                                                "${(_inPoolTotal * _price).toStringAsFixed(2)} USD",
                                                maxLines: 1,
                                                minFontSize: 8.0,
                                                textAlign: TextAlign.end,
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          GradientText(
                                            "${AppLocalizations.of(context)!.staking_contrib}:",
                                            gradient: const LinearGradient(colors: [
                                              Colors.white70,
                                              Colors.white54,
                                            ]),
                                            // textAlign: TextAlign.end,
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                              child: AutoSizeText(
                                                "${_percentage.toStringAsFixed(3)}%",
                                                maxLines: 1,
                                                minFontSize: 8.0,
                                                textAlign: TextAlign.end,
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                      child: Row(
                                        children: [
                                          GradientText(
                                            "${AppLocalizations.of(context)!.staking_est}:",
                                            gradient: const LinearGradient(colors: [
                                              Colors.white70,
                                              Colors.white54,
                                            ]),
                                            // textAlign: TextAlign.end,
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                                              child: AutoSizeText(
                                                "${_estimated.toStringAsFixed(3)} ${_coinActive.cryptoId!}/${AppLocalizations.of(context)!.staking_day.toString().toUpperCase()}",
                                                maxLines: 1,
                                                minFontSize: 8.0,
                                                textAlign: TextAlign.end,
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0, color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_detailsExtended) {
                                _animationController!.reverse();
                                _detailsExtended = false;
                              } else {
                                _animationController!.forward();
                                _detailsExtended = true;
                              }
                              setState(() {});
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    GradientText(
                                      _detailsExtended ? AppLocalizations.of(context)!.st_less : AppLocalizations.of(context)!.st_more,
                                      gradient: const LinearGradient(colors: [
                                        Colors.white70,
                                        Colors.white54,
                                      ]),
                                      // textAlign: TextAlign.end,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0, color: Colors.white70),
                                    ),
                                    RotatedBox(
                                      quarterTurns: _detailsExtended ? 2 : 0,
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white54,
                                        size: 18.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: AutoSizeTextField(
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                                TextInputFormatter.withFunction((oldValue, newValue) {
                                  try {
                                    final text = newValue.text;
                                    if (text.isNotEmpty) double.parse(text);
                                    return newValue;
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                  return oldValue;
                                }),
                              ],
                              maxLines: 1,
                              minFontSize: 12.0,
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white, fontSize: 18.0),
                              autocorrect: false,
                              focusNode: numberFocusNode,
                              controller: _amountController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black26,
                                contentPadding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white54, fontSize: 14.0),
                                hintText: AppLocalizations.of(context)!.stake_amount,
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white12),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white12),
                                ),
                              ),
                            ),
                          ),
                          PercentSwitchWidget(
                            key: _percentageKey,
                            changePercent: _changePercentage,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              "${AppLocalizations.of(context)!.min_withdraw} $_min \n${AppLocalizations.of(context)!.staking_lock_coins}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white30),
                            )),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                            child: SlideAction(
                              sliderButtonIconPadding: 5.0,
                              sliderButtonIconSize: 50.0,
                              borderRadius: 5.0,
                              text: AppLocalizations.of(context)!.stake_swipe,
                              innerColor: Colors.white.withOpacity(0.02),
                              outerColor: Colors.black.withOpacity(0.12),
                              elevation: 0.5,
                              // submittedIcon: const Icon(Icons.check, size: 30.0, color: Colors.lightGreenAccent,),
                              submittedIcon: const CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.lightGreenAccent,
                              ),
                              sliderButtonIcon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white70,
                                size: 35.0,
                              ),
                              sliderRotate: false,
                              textStyle: const TextStyle(color: Colors.white24, fontSize: 24.0),
                              key: _keyStake,
                              onSubmit: () {
                                _createWithdrawal();
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.stake_wait,
                              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white30),
                            )),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          _staking
                              ? Column(
                                  children: [
                                    IgnorePointer(
                                      ignoring: _amountReward == "0.0" ? true : false,
                                      child: Opacity(
                                        opacity: _amountReward == "0.0" ? 0.6 : 1.0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                            child: FlatCustomButton(
                                              onTap: () {
                                                if (!_loadingReward) {
                                                  _unStake(1);
                                                }
                                              },
                                              color: const Color(0xb26cb30b),
                                              child: SizedBox(
                                                  height: 40.0,
                                                  child: Center(
                                                      child: _loadingReward
                                                          ? const Padding(
                                                              padding: EdgeInsets.all(3.0),
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2.0,
                                                                color: Colors.white70,
                                                              ),
                                                            )
                                                          : Text(
                                                              AppLocalizations.of(context)!.stake_get_reward,
                                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18.0, color: Colors.white70, fontWeight: FontWeight.w600),
                                                            ))),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                                        child: FlatCustomButton(
                                          onTap: () {
                                            if (!_loadingCoins) {
                                              _unStake(0);
                                            }
                                          },
                                          color: const Color(0xb20b8cb3),
                                          child: SizedBox(
                                              height: 40.0,
                                              child: Center(
                                                  child: _loadingCoins
                                                      ? const Padding(
                                                          padding: EdgeInsets.all(3.0),
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2.0,
                                                            color: Colors.white70,
                                                          ),
                                                        )
                                                      : Text(
                                                          AppLocalizations.of(context)!.stake_get_all,
                                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18.0, color: Colors.white70, fontWeight: FontWeight.w600),
                                                        ))),
                                        )),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changeTime(int time) {
    _typeGraph = 0;
    _typeGraph = time;
    _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
  }

  _blockSwipe(bool b) {
    widget.blockTouch(b);
  }

  String _formatDecimal(Decimal d) {
    try {
      if (d == Decimal.zero) return "0.0";
      var str = d.toString();
      var split = str.split(".");
      var subs = split[1];
      var count = 0;
      loop:
      for (var i = 0; i < subs.length; i++) {
        if (subs[i] == "0") {
          count++;
        } else {
          break loop;
        }
      }
      if (count > 8) {
        return d.toStringAsExponential(3);
      }
      return _formatPrice(d);
    } catch (e) {
      return "0.0";
    }
  }

  String _formatPrice(Decimal d) {
    try {
      if (d == Decimal.zero) return "0.0";
      var split = d.toString().split('.');
      var decimal = split[1];
      if (decimal.length >= 8) {
        var sub = decimal.substring(0, 8);
        return "${split[0]}.$sub";
      } else {
        return d.toString();
      }
    } catch (e) {
      return d.toString();
    }
  }

  String _formatPriceString(String d) {
    try {
      var split = d.toString().split('.');
      var decimal = split[1];
      if (decimal.length >= 9) {
        var sub = decimal.substring(0, 8);
        return ("${split[0]}.$sub").trim();
      } else {
        return d.toString().trim();
      }
    } catch (e) {
      return "0";
    }
  }

  _getFees() async {
    try {
      // _free = widget.free;
      final response = await _interface.get("Transfers/GetWithdrawFee?coinId=${widget.activeCoin.id!}");
      var d = Fees.fromJson(response);
      setState(() {
        _fee = d.data!.fee!;
        _min = d.data!.crypto!.minWithdraw!;
      });
    } catch (e) {
      setState(() {
        // _error = true;
      });
      debugPrint(e.toString());
    }
  }

  _createWithdrawal() async {
    Dialogs.openWaitBox(context);
    String serverTypeRckt = "<Rocketbot Service error>";
    String serverTypePos = "<Rocketbot POS Service error>";
    String problem = serverTypeRckt;
    WithdrawConfirm? rw;
    var amt = double.parse(_amountController.text);
    bool minAmount = amt < _min!;

    if (amt > _free || _amountController.text.isEmpty) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.staking_not_enough);
      _keyStake.currentState!.reset();
      return;
    }

    if (widget.depositAddress == null || widget.depositAddress!.isEmpty) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Data err");
      _keyStake.currentState!.reset();
      return;
    }

    if (minAmount) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.staking_not_min.replaceAll("{1}", _min!.toString()).replaceAll("{2}", _coinActive.cryptoId!));
      _keyStake.currentState!.reset();
      return;
    }

    try {
      await _getStakingDetails();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      Map<String, dynamic> query = {"coinId": _coinActive.id!, "fee": _fee, "amount": amt, "toAddress": widget.depositPosAddress};

      final response = await _interface.post("Transfers/CreateWithdraw", query);
      var pwid = WithdrawID.fromJson(response);
      Map<String, dynamic> queryID = {
        "id": pwid.data!.pgwIdentifier!,
      };
      var resWith = await _interface.post("Transfers/ConfirmWithdraw", queryID);
      rw = WithdrawConfirm.fromJson(resWith);
      await AppDatabase().addTX(rw.data!.pgwIdentifier!, _coinActive.id!, double.parse(_amountController.text), widget.depositAddress!);
      problem = serverTypePos;
      Map<String, dynamic> m = {
        "idCoin": _coinActive.id!,
        "depAddr": widget.depositAddress,
        "amount": double.parse(_amountController.text),
        "pwd_id": rw.data!.pgwIdentifier!,
      };
      await _interface.post("stake/set", m, pos: true);
      _lostPosTX();
    } on BadRequestException catch (r) {
      if (mounted) Navigator.of(context).pop();
      int messageStart = r.toString().indexOf("{");
      int messageEnd = r.toString().indexOf("}");
      var s = r.toString().substring(messageStart, messageEnd + 1);
      var js = json.decode(s);
      var wm = WithdrawalsModels.fromJson(js);
      _keyStake.currentState!.reset();
      if (mounted) Dialogs.openAlertBox(context, wm.message!, "${wm.error!}\n\n$problem");
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _keyStake.currentState!.reset();
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "$e\n\n$problem");
    }

    if (rw == null) {
      _keyStake.currentState!.reset();
      if (mounted) Navigator.of(context).pop();
      if (mounted) Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Couldn't send coins for Staking \n\n$serverTypeRckt");
    }

    _amountController.clear();
    var preFree = 0.0;
    var resB = await _interface.get("User/GetBalance?coinId=${_coinActive.id!}");
    var rs = BalancePortfolio.fromJson(resB);
    preFree = rs.data!.free!;
    _free = preFree;
    widget.changeFree(preFree);
    _keyStake.currentState!.reset();
    await _getStakingDetails();
    _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
    setState(() {});
    if (mounted) Navigator.of(context).pop();
  }

  _lostPosTX() async {
    List<PGWIdentifier> l = await AppDatabase().getUnfinishedTX();
    for (var element in l) {
      var coindID = element.getCoinID();
      var pgwid = element.getPGW();
      if (element.getStatus() == 0) {
        String? txid;
        await Future.doWhile(() async {
          try {
            await Future.delayed(const Duration(seconds: 3));
            final withdrawals = await _interface.get("Transfers/GetWithdraws?page=1&pageSize=10&coinId=$coindID");
            List<DataWithdrawals>? withrld = WithdrawalsModels.fromJson(withdrawals).data;
            for (var el in withrld!) {
              if (el.pgwIdentifier! == pgwid) {
                if (el.transactionId != null) {
                  txid = el.transactionId;
                  return false;
                }
              }
            }
          } catch (e) {
            return true;
          }
          return true;
        });

        try {
          Map<String, dynamic> m = {
            "pwd_id": pgwid,
            "tx_id": txid,
          };
          await _interface.post("stake/confirm", m, pos: true);
          await AppDatabase().finishTX(pgwid!);
          await Future.delayed(const Duration(seconds: 3));
          _getPos();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  _unStake(int rewardParam) async {
    if (_loadingReward || _loadingCoins) {
      return;
    }
    Dialogs.openWaitBox(context);
    if (rewardParam == 1) {
      _loadingReward = true;
    } else {
      _loadingCoins = true;
    }
    setState(() {});
    try {
      Map<String, dynamic> m = {"idCoin": _coinActive.id!, "rewardParam": rewardParam};

      await _interface.post("stake/withdraw", m, pos: true);
      var preFree = 0.0;
      var resB = await _interface.get("User/GetBalance?coinId=${_coinActive.id!}");
      var rs = BalancePortfolio.fromJson(resB);
      preFree = rs.data!.free!;
      _free = preFree;
      widget.changeFree(preFree);
      await _getStakingDetails();
      _stakeBloc!.fetchStakeData(_coinActive.id!, _typeGraph);
      var conf = _coinActive.requiredConfirmations;
      if (rewardParam == 1) {
        _loadingReward = false;
      } else {
        _loadingCoins = false;
      }
      setState(() {});
      if (mounted) {
        Navigator.of(context).pop();
        Dialogs.openAlertBox(context, AppLocalizations.of(context)!.alert, AppLocalizations.of(context)!.staking_with_info.replaceAll("{1}", conf.toString()));
      }
    } catch (e) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, e.toString());
    }
  }

  _changePercentage(double d) {
    _amountController.text = _formatPriceString(((_free - _fee!) * d).toString());
    setState(() {});
  }

  @override
  void onDetached() {
    if (!_paused) {
      _paused = true;
    }
  }

  @override
  void onInactive() {
    if (!_paused) {
      _paused = true;
    }
  }

  @override
  void onPaused() {
    if (!_paused) {
      _paused = true;
    }
  }

  @override
  void onResumed() {
    if (_paused) {
      _getPos();
      _paused = false;
    }
  }

  void _getFocusIOS() {
    if (Platform.isIOS) {
      numberFocusNode.addListener(() {
        bool hasFocus = numberFocusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      });
    }
  }
}
