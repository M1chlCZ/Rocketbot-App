import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

import '../support/auto_size_text_field.dart';

class DepositPage extends StatefulWidget {
  final Coin? coin;
  final double? free;
  final String? depositAddr;

  const DepositPage({Key? key, this.coin, this.free, this.depositAddr}) : super(key: key);

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final TextEditingController _addressController = TextEditingController();
  var popMenu = false;


  @override
  void initState() {
    super.initState();
    _addressController.text = widget.depositAddr!;
  }

  _getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    // print(data!.text!);
    setState(() {
        _addressController.text = data!.text!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          SingleChildScrollView(
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
                      Text(AppLocalizations.of(context)!.receive,
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(
                        width: 50,
                      ),
                      // SizedBox(
                      //     height: 30,
                      //     child: TimeRangeSwitcher(
                      //       changeTime: _changeTime,
                      //     )),
                      // Expanded(
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(right: 8.0),
                      //       child: SizedBox(
                      //         height: 30,
                      //         width: 25,
                      //         child: NeuButton(
                      //           onTap: () async {
                      //             // await const FlutterSecureStorage().delete(key: "token");
                      //             // Navigator.of(context).pushReplacement(
                      //             //     PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                      //             //       return const LoginScreen();
                      //             //     }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                      //             //       return FadeTransition(opacity: animation, child: child);
                      //             //     }));
                      //           },
                      //           icon: const Icon(
                      //             Icons.more_vert,
                      //             color: Colors.white70,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100.0,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.coin == null
                          ? const Icon(
                              Icons.monetization_on,
                              size: 50.0,
                              color: Colors.white,
                            )
                          : SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CachedNetworkImage(
                                imageUrl: 'https://app.rocketbot.pro/Image?imageId=' +
                                widget.coin!.imageSmallid!,
                                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                                //     CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        height: 65.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    widget.coin == null
                                        ? AppLocalizations.of(context)!
                                            .choose_coin
                                        : widget.coin!.ticker!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(fontSize: 18.0),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: SizedBox(
                                    width: 70,
                                    child: AutoSizeText(
                                      widget.coin == null
                                          ? 'Token'
                                          : widget.coin!.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                      minFontSize: 8,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    widget.free == null
                                        ? (0.0).toString()
                                        : widget.free!.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(fontSize: 18.0),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  width: double.infinity,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    color: Color(0xFF252525),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 8.0),
                      child: AutoSizeTextField(
                        maxLines: 1,
                        minFontSize: 6.0,
                        style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white, fontSize: 14.0),
                        autocorrect: false,
                        readOnly: true,
                        controller: _addressController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      isDense: true,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: Colors.white54, fontSize: 14.0),
                      hintText: AppLocalizations.of(context)!.address,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeuButton(
                        height: 40.0,
                        width: 40.0,
                        onTap: () {
                          _getClipBoardData();
                        },
                        child: SizedBox(
                            width: 20.0, child: Image.asset('images/copy.png')),
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      NeuButton(
                        height: 40.0,
                        width: 40.0,
                        onTap: () {
                          setState(() {
                            if (popMenu) {
                              popMenu = false;
                            } else {
                              popMenu = true;
                            }
                          });
                        },
                        child: SizedBox(
                            width: 20.0, child: Image.asset('images/share.png')),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 0.5,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  color: Colors.white30,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  AppLocalizations.of(context)!.or_scan_qr,
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                NeuButton(
                  onTap: () {
                    _openQR(context, widget.coin!.fullName!);
                  },
                  color: Colors.white,
                  width: 200,
                  height: 200,
                  // child: Image.asset("images/qr_code_scan.png"),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    margin: const EdgeInsets.all(0.0),
                    // child: Image.asset("images/qr_code_scan.png"),
                    child: QrImage(
                      dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square),
                      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square),
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      data: widget.depositAddr!,
                      foregroundColor: Colors.black87,
                      version: QrVersions.auto,
                      size: 200,
                      gapless: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: popMenu ? true : false,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    popMenu = false;
                  });
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Container(
                    color: Colors.black12,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )),
          ),
          Positioned(
              top: 180.0,
              right: 120.0,
              child: IgnorePointer(
                ignoring: popMenu ? false : true,
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
                        width: 140,
                        color: const Color(0xFF1B1B1B),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 40,
                                child: Center(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: 140,
                                      child: TextButton.icon(
                                        icon: Image.asset(
                                          'images/telegram.png',
                                          color: Colors.white,
                                          fit: BoxFit.fitWidth,
                                          width: 15.0,
                                        ),
                                        label: Text(
                                          'Telegram',
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
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child:
                                  Container(height: 0.5, color: Colors.white12),
                            ),
                            SizedBox(
                                height: 40,
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: SizedBox(
                                    width: 140,
                                    child: TextButton.icon(
                                      icon: Image.asset(
                                        'images/discord.png',
                                        color: Colors.white,
                                        fit: BoxFit.fitWidth,
                                        width: 15.0,
                                      ),
                                      label: Text(
                                        'Discord   ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(fontSize: 14.0),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => qrColors(states)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                  side: const BorderSide(
                                                      color: Colors
                                                          .transparent)))),
                                      onPressed: () {},
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child:
                                  Container(height: 0.5, color: Colors.white12),
                            ),
                            SizedBox(
                                height: 40,
                                child: Center(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: 140,
                                      child: TextButton.icon(
                                        icon: Image.asset(
                                          'images/sms.png',
                                          color: Colors.white,
                                          fit: BoxFit.fitWidth,
                                          width: 15.0,
                                        ),
                                        label: Text(
                                          'SMS         ',
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
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child:
                                  Container(height: 0.5, color: Colors.white12),
                            ),
                            SizedBox(
                                height: 40,
                                child: Center(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: 140,
                                      child: TextButton.icon(
                                        icon: Image.asset(
                                          'images/email.png',
                                          color: Colors.white,
                                          fit: BoxFit.fitWidth,
                                          width: 15.0,
                                        ),
                                        label: Text(
                                          'E-mail     ',
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
                                        onPressed: () {},
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
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

  _openQR(context, String qr) async {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
            child: Dialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF9F9FA4)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Wrap(children: [
                Container(
                  width: 400.0,
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0, bottom: 2.0),
                          child: SizedBox(
                            width: 380,
                            child: AutoSizeText(
                              "Deposit address",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 8.0,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      fontSize: 22.0, color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        '(tap to copy, long press to share)',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontSize: 14.0, color: Colors.black54),
                      )),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: widget.depositAddr!));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("QR code copied to clipboard"),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.fixed,
                              elevation: 5.0,
                            ));
                            Navigator.pop(context);
                          },
                          onLongPress: () {
                            Vibration.vibrate(duration: 200);
                            Share.share(qr);
                            Navigator.pop(context);
                          },
                          child: QrImage(
                            dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square),
                            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square),
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            data: widget.depositAddr!,
                            foregroundColor: Colors.black87,
                            version: QrVersions.auto,
                            // size: 250,
                            gapless: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          );
        });
  }
}
