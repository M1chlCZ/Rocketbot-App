import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/models/balance_portfolio.dart';
import 'package:rocketbot/models/fees.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/stake_check.dart';
import 'package:rocketbot/models/withdraw_confirm.dart';
import 'package:rocketbot/models/withdraw_pwid.dart';
import 'package:rocketbot/netInterface/app_exception.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/support/utils.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/percent_switch_widget.dart';
import 'package:rocketbot/widgets/stake_graph.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../component_widgets/button_neu.dart';
import '../models/balance_list.dart';
import '../models/coin.dart';
import '../models/stake_data.dart';
import '../widgets/coin_price_graph.dart';
import '../widgets/time_range_switch.dart';

class StakingPage extends StatefulWidget {
  final Coin activeCoin;
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
  _StakingPageState createState() => _StakingPageState();
}

class _StakingPageState extends State<StakingPage>
    with SingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();
  final NetInterface _interface = NetInterface();
  final _graphKey = GlobalKey<CoinPriceGraphState>();
  final _percentageKey= GlobalKey<PercentSwitchWidgetState>();
  final GlobalKey<SlideActionState> _keyStake = GlobalKey();
  final TextEditingController _amountController = TextEditingController();
  List<Stakes>? _stakeData;
  late Coin _coinActive;

  Decimal totalCoins = Decimal.zero;
  Decimal totalUSD = Decimal.zero;
  Decimal usdCost = Decimal.zero;
  bool portCalc = false;
  bool _staking = false;
  bool _loadingReward = false;
  bool _loadingCoins = false;

  double _amountStaked = 0.0;
  double _unconfirmedAmount = 0.0;
  String _amountReward = "0.0";
  double _free = 0.0;

  double? _fee;
  double? _min;

  @override
  void initState() {
    super.initState();
    _coinActive = widget.activeCoin;
    _free = widget.free;
    _amountController.addListener(() {
      _percentageKey.currentState!.deActivate();
    });

    _getPos();
    _getFees();
  }

  @override
  void dispose() {
    // _listCoins.clear();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _getPos() {
    _getStakeData();
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
      setState(() {});
    } else {
      _amountStaked = sc.amount!;
      _unconfirmedAmount = sc.unconfirmed!;
      _amountReward = _formatDecimal(Decimal.parse(sc.stakesAmount.toString()));
      _staking = true;
      setState(() {});
    }
  }

  void _getStakeData() async {
    Map<String, dynamic> m = {
      "idCoin": _coinActive.id!,
      // "dateTime": "2022-03-04 23:00:00"
      "datetime": Utils.getUTC()
    };
    var rs = await _interface.post("stake/list", m, pos: true);
    if (rs == null) return;
    StakingData st = StakingData.fromJson(rs);
    // if (st.stakes == null) return;
    _stakeData = st.stakes;
    _stakeData ??= [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
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
                  const SizedBox(
                    width: 60,
                  ),
                  SizedBox(
                      height: 30,
                      child: IgnorePointer(
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: TimeRangeSwitcher(
                                changeTime: _changeTime,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Stack(
              children: [
                IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GradientText(
                          "|STAKING \n|EARLY \n|ACCESS",
                          gradient: LinearGradient(colors: [
                            Colors.white54,
                            Colors.white10.withOpacity(0.0),
                          ]),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 48.0, color: Colors.white12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 240,
                    child: _stakeData != null
                        ? CoinStakeGraph(
                            key: _graphKey,
                            stake: _stakeData,
                            activeCoin: _coinActive,
                            time: 24,
                            blockTouch: _blockSwipe,
                          )
                        : HeartbeatProgressIndicator(
                            startScale: 0.01,
                            endScale: 0.4,
                            child: const Image(
                              image: AssetImage('images/rocketbot_logo.png'),
                              color: Colors.white30,
                            ),
                          )),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.white30, width: 0.5)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GradientText(
                  _coinActive.cryptoId!,
                  gradient: const LinearGradient(colors: [
                    Colors.white70,
                    Colors.white54,
                  ]),
                  // textAlign: TextAlign.end,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 24.0, color: Colors.white70),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 12.0, color: Colors.white70),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.white30, width: 0.5)),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Row(
                  children: [
                    GradientText(
                      AppLocalizations.of(context)!.stake_available + ":",
                      gradient: const LinearGradient(colors: [
                        Colors.white70,
                        Colors.white54,
                      ]),
                      // textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18.0, color: Colors.white70),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                        child: AutoSizeText(
                          _free.toString() + " " + _coinActive.cryptoId!,
                          maxLines: 1,
                          minFontSize: 8.0,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 18.0, color: Colors.white70),
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
                      AppLocalizations.of(context)!.stake_staked_amount +  ":",
                      gradient: const LinearGradient(colors: [
                        Colors.white70,
                        Colors.white54,
                      ]),
                      // textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18.0, color: Colors.white70),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                        child: AutoSizeText(
                          _formatDecimal(
                                  Decimal.parse(_amountStaked.toString())) +
                              " " +
                              _coinActive.cryptoId!,
                          maxLines: 1,
                          minFontSize: 8.0,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 18.0, color: Colors.white70),
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
                              AppLocalizations.of(context)!.stake_unconfirmed + ":",
                              gradient: const LinearGradient(colors: [
                                Colors.white70,
                                Colors.white54,
                              ]),
                              // textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 12.0, color: Colors.white70),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, top: 1.0),
                                child: AutoSizeText(
                                  _unconfirmedAmount.toStringAsFixed(3) +
                                      " " +
                                      _coinActive.cryptoId!,
                                  maxLines: 1,
                                  minFontSize: 8.0,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontSize: 14.0,
                                          color: Colors.white70),
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
                      AppLocalizations.of(context)!.stake_reward + ":",
                      gradient: const LinearGradient(colors: [
                        Colors.white70,
                        Colors.white54,
                      ]),
                      // textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18.0, color: Colors.white70),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 1.0),
                        child: AutoSizeText(
                          _amountReward + " " + _coinActive.cryptoId!,
                          maxLines: 1,
                          minFontSize: 8.0,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 18.0, color: Colors.white70),
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
                border:
                    Border(top: BorderSide(color: Colors.white12, width: 0.5)),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: AutoSizeTextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    try {
                      final text = newValue.text;
                      if (text.isNotEmpty) double.parse(text);
                      return newValue;
                    } catch (e) {}
                    return oldValue;
                  }),
                ],
                maxLines: 1,
                minFontSize: 12.0,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white, fontSize: 18.0),
                autocorrect: false,
                controller: _amountController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white54, fontSize: 14.0),
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
            SizedBox(
              width: double.infinity,
              child: Center(
                  child: Text(
                      AppLocalizations.of(context)!.min_withdraw + " " + _min.toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white30),
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
                outerColor: Colors.white.withOpacity(0.02),
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
                textStyle:
                    const TextStyle(color: Colors.white24, fontSize: 24.0),
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
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white30),
              )),
            ),
            const SizedBox(
              height: 20.0,
            ),
            _staking
                ? Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: FlatCustomButton(
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    fontSize: 18.0,
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ))),
                            onTap: () {
                              _unStake(1);
                            },
                            color: const Color(0xb26cb30b),
                          )),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: FlatCustomButton(
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    fontSize: 18.0,
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ))),
                            onTap: () {
                              _unStake(0);
                            },
                            color: const Color(0xb20b8cb3),
                          )),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _changeTime(int time) {
    setState(() {
      _graphKey.currentState!.changeTime(time);
    });
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
      var _split = d.toString().split('.');
      var _decimal = _split[1];
      if (_decimal.length >= 8) {
        var _sub = _decimal.substring(0, 8);
        return _split[0] + "." + _sub;
      } else {
        return d.toString();
      }
    } catch (e) {
      return d.toString();
    }
  }

  _getFees() async {
    try {
      // _free = widget.free;
      final response = await _interface
          .get("Transfers/GetWithdrawFee?coinId=${widget.activeCoin.id!}");
      var d = Fees.fromJson(response);
      setState(() {
        _fee = d.data!.fee!;
        _min = d.data!.crypto!.minWithdraw!;
      });
    } catch (e) {
      setState(() {
        // _error = true;
      });
      print(e);
    }
  }

  _createWithdrawal() async {
    Dialogs.openWaitBox(context);
    String _serverTypeRckt = "< Rocketbot Service error >";
    String _serverTypePos= "< POS Service error >";
    bool _serverRckt = true;

    var amt = double.parse(_amountController.text);

    if(amt > _free) {
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, "Not enough enough coins to complete the operation!");
      return;
    }

    Map<String, dynamic> _query = {
      "coinId": _coinActive.id!,
      "fee": _fee,
      "amount": amt,
      "toAddress": widget.depositPosAddress
    };

    try {
      final response =
      await _interface.post("Transfers/CreateWithdraw", _query);
      var pwid = WithdrawID.fromJson(response);
      Map<String, dynamic> _queryID = {
        "id": pwid.data!.pgwIdentifier!,
      };
      var resWith = await _interface.post("Transfers/ConfirmWithdraw", _queryID);
      var rw = WithdrawConfirm.fromJson(resWith);

      String? txid;
      await Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 3));
        final _withdrawals = await _interface.get("Transfers/GetWithdraws?page=1&pageSize=10&coinId=" + _coinActive.id!.toString());
        List<DataWithdrawals>? _with = WithdrawalsModels.fromJson(_withdrawals).data;
        for (var element in _with!) {
          if(element.pgwIdentifier == rw.data!.pgwIdentifier!) {
            if(element.transactionId != null) {
              txid = element.transactionId;
              return false;
            }
          }
        }
        return true;
      });
      _serverRckt = false;
      Map<String, dynamic> m = {
        "idCoin": _coinActive.id!,
        "depAddr": widget.depositAddress,
        "amount": double.parse(_amountController.text),
        "tx_id" : txid!
      };

      await _interface.post("stake/set", m, pos: true);
      _amountController.clear();
      _serverRckt = true;
      var preFree = 0.0;
      var resB =
      await _interface.get("User/GetBalance?coinId=" + _coinActive.id!.toString());
      var rs = BalancePortfolio.fromJson(resB);
      preFree = rs.data!.free!;
      _free = preFree;
      widget.changeFree(preFree);
      _keyStake.currentState!.reset();
      _getPos();
      Navigator.of(context).pop();
    } on BadRequestException catch (r, e) {
      int messageStart = r.toString().indexOf("{");
      int messageEnd = r.toString().indexOf("}");
      var s = r.toString().substring(messageStart, messageEnd + 1);
      var js = json.decode(s);
      var wm = WithdrawalsModels.fromJson(js);
      // _showError(wm.error!);
      _keyStake.currentState!.reset();
      Navigator.of(context).pop();
      Dialogs.openAlertBox(context, wm.message!, wm.error! + "\n\n" +(_serverRckt ? _serverTypeRckt : _serverTypePos));
    } catch (e) {
      _keyStake.currentState!.reset();
      Navigator.of(context).pop();
      Dialogs.openAlertBox(
          context, AppLocalizations.of(context)!.error, e.toString()  + "\n\n" +(_serverRckt ? _serverTypeRckt : _serverTypePos));
    }
  }

  _unStake(int rewardParam) async {
    if (rewardParam == 1) {
      _loadingReward = true;
    } else {
      _loadingCoins = true;
    }
    setState(() {});
    try {
      Map<String, dynamic> m = {
        "idCoin": _coinActive.id!,
        "rewardParam": rewardParam
      };

      await _interface.post("stake/withdraw", m, pos: true);
      await Future.delayed(const Duration(seconds: 10));
      var preFree = 0.0;
      var resB = await _interface
          .get("User/GetBalance?coinId=" + _coinActive.id!.toString());
      var rs = BalancePortfolio.fromJson(resB);
      preFree = rs.data!.free!;
      _free = preFree;
      widget.changeFree(preFree);
      _getPos();
      if (rewardParam == 1) {
        _loadingReward = false;
      } else {
        _loadingCoins = false;
      }
      setState(() {});
    } catch (e) {
      Dialogs.openAlertBox(
          context, AppLocalizations.of(context)!.error, e.toString());
    }
  }

  _changePercentage(double d) {
    _amountController.text = (_free * d).toString();
    setState(() { });
  }
}
