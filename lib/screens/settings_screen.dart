import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/main.dart';
import 'package:rocketbot/screens/auth_screen.dart';
import 'package:rocketbot/screens/login_screen.dart';
import 'package:rocketbot/screens/security_screen.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/globals.dart' as globals;
import 'package:rocketbot/support/secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  var dropLanguageValue = globals.LANGUAGES[0];
  var firstValue = false;
  var secondValue = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      if (mounted) {
        final Locale appLocale = Localizations.localeOf(context);
        var i = globals.LANGUAGES_CODES
            .indexWhere((element) => element.contains(appLocale.toString()));
        if (i != -1) {
          setState(() {
            dropLanguageValue = globals.LANGUAGES[i];
          });
        } else {
          setState(() {
            dropLanguageValue = globals.LANGUAGES[0];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
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
                      Text(AppLocalizations.of(context)!.settings_screen,
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.settings_main,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 14.0, color: Colors.white24),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.white12,
                      ),
                      // const SizedBox(
                      //   height: 20.0,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const SizedBox(
                      //       width: 7,
                      //     ),
                      //     Text('Lorem Ipsum',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headline4!
                      //             .copyWith(
                      //                 fontSize: 14.0, color: Colors.white)),
                      //     const Expanded(
                      //       child: SizedBox(
                      //       ),
                      //     ),
                      //     NeuContainer(
                      //       width: 60,
                      //       height: 25,
                      //       child: FlutterSwitch(
                      //         activeSwitchBorder: Border.all(
                      //           color: Colors.green,
                      //           width: 2.0,
                      //         ),
                      //         inactiveSwitchBorder: Border.all(
                      //           color: Colors.red,
                      //           width: 2.0,
                      //         ),
                      //         inactiveToggleColor: Colors.red,
                      //         activeToggleColor: Colors.green,
                      //         activeColor: Colors.transparent,
                      //         inactiveColor: Colors.transparent,
                      //         width: 40.0,
                      //         height: 15.0,
                      //         valueFontSize: 5.0,
                      //         toggleSize: 10.0,
                      //         value: firstValue,
                      //         borderRadius: 14.0,
                      //         padding: 1.0,
                      //         showOnOff: false,
                      //         onToggle: (val) {
                      //           setState(() {
                      //             firstValue = val;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     const SizedBox(
                      //       width: 12,
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 7,
                          ),
                          Text(AppLocalizations.of(context)!.language,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                  fontSize: 14.0, color: Colors.white)),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.4,
                          // ),
                          const SizedBox(
                            width: 120,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: NeuContainer(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: dropLanguageValue,
                                      isDense: true,
                                      onChanged: (String? val) {
                                        // print(val!);
                                        dropLanguageValue = val!;
                                        setState(() {
                                          Locale l;
                                          int index =  globals.LANGUAGES.indexWhere((values) => values.contains(val));
                                          // print(index);
                                          var ls = globals.LANGUAGES_CODES[index].split('_');
                                          if(ls.length == 1) {
                                            l = Locale(ls[0], '');
                                          }else if(ls.length == 2) {
                                            l = Locale(ls[0], ls[1]);
                                          }else{
                                            l = Locale.fromSubtags(countryCode: ls[2], scriptCode: ls[1], languageCode: ls[0]);
                                          }
                                          MyApp.of(context)?.setLocale(l);
                                          SecureStorage.writeStorage(key: globals.LOCALE_APP, value: globals.LANGUAGES_CODES[index]);
                                        });
                                      },
                                      items: globals.LANGUAGES
                                          .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: SizedBox(
                                              width: 70,
                                              child: Text(e))))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.settings_privacy,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 14.0, color: Colors.white24),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.white12,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: Card(
                            elevation: 0,
                            color: Theme.of(context).canvasColor,
                            margin: EdgeInsets.zero,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: InkWell(
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                _handlePIN();
                              },
                              // widget.coinSwitch(widget.coin);
                              // widget.activeCoin(widget.coin.coin!);

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!
                                            .sc_security,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                                fontSize: 14.0,
                                                color: Colors.white)),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    NeuButton(
                                        height: 25,
                                        width: 20,
                                        onTap: () async {
                                          _handlePIN();
                                        },
                                        child: const Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white,
                                          size: 22.0,
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: Card(
                            elevation: 0,
                            color: Theme.of(context).canvasColor,
                            margin: EdgeInsets.zero,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: InkWell(
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                Dialogs.openLogOutBox(context, () async {
                                  await const FlutterSecureStorage().deleteAll();
                                  if (mounted) {
                                    Navigator.of(context)
                                      .pushReplacement(
                                      PageRouteBuilder(
                                          pageBuilder:
                                              (BuildContext
                                          context,
                                              _,
                                              __) {
                                            return const LoginScreen();
                                          }, transitionsBuilder: (_,
                                          Animation<double>
                                          animation,
                                          __,
                                          Widget child) {
                                        return FadeTransition(
                                            opacity: animation,
                                            child: child);
                                      }));
                                  }
                                });
                              },
                              // widget.coinSwitch(widget.coin);
                              // widget.activeCoin(widget.coin.coin!);

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(AppLocalizations.of(context)!.log_out,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                                fontSize: 14.0,
                                                color: Colors.white)),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    NeuButton(
                                        height: 25,
                                        width: 20,
                                        onTap: () async {
                                          Dialogs.openLogOutBox(context, () async {
                                            await const FlutterSecureStorage().deleteAll();
                                            if (mounted) {
                                              Navigator.of(context)
                                                .pushReplacement(
                                                    PageRouteBuilder(
                                                        pageBuilder:
                                                            (BuildContext
                                                                    context,
                                                                _,
                                                                __) {
                                              return const LoginScreen();
                                            }, transitionsBuilder: (_,
                                                            Animation<double>
                                                                animation,
                                                            __,
                                                            Widget child) {
                                              return FadeTransition(
                                                  opacity: animation,
                                                  child: child);
                                            }));
                                            }
                                          });
                                        },
                                        child: const Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white,
                                          size: 22.0,
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _handlePIN() async {
    var bl = false;
    String? p = await SecureStorage.readStorage(key: "PIN");
    if (p == null) {
      bl = true;
    }
    if (mounted) {
      Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
          return AuthScreen(
            setupPIN: bl,
            type: 1,
          );
        }, transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        }))
        .then((value) => _authCallback(value));
    }
  }

  void _authCallback(bool? b) async {
    if (b == null || b == false) return;
    Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return const SecurityScreen();
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }
}
