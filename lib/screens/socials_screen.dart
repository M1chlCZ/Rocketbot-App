import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/models/socials.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';

class SocialScreen extends StatefulWidget {
  final List<int> socials;

  const SocialScreen({Key? key, required this.socials}) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends LifecycleWatcherState<SocialScreen> {
  final NetInterface _interface = NetInterface();
  final TextEditingController _discordTextController = TextEditingController();
  List<int> _socials = [];
  bool _paused = false;

  Socials? _discord;
  Socials? _twitter;
  Socials? _telegram;

  bool _discordDetails = false;

  @override
  void initState() {
    _socials = widget.socials;
    super.initState();
    _loadDirectives();
  }

  _loadDirectives() async {
   await _loadDiscordDirective();
   await _loadTwitterDirective();
   await _loadTelegramDirective();
  }

  _loadDiscordDirective() async {
    Map<String, dynamic> _request = {
      "socialMedia": 1,
    };
    try {
      final response =
          await _interface.post("Auth/CreateAccountConnectingKey", _request);
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        _discord = d;
        _discordTextController.text = 'connect ' + _discord!.data!.key!;
        setState(() {});
      } else {
        print(d.error);
      }
    } catch (e) {
      print(e);
    }
  }

  _loadTwitterDirective() async {
    Map<String, dynamic> _request = {
      "socialMedia": 3,
    };
    try {
      final response =
          await _interface.post("Auth/CreateAccountConnectingKey", _request);
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        _twitter = d;
        setState(() {});
      } else {
        print(d.error);
      }
    } catch (e) {
      print(e);
    }
  }

  _loadTelegramDirective() async {
    Map<String, dynamic> _request = {
      "socialMedia": 2,
    };
    try {
      final response =
          await _interface.post("Auth/CreateAccountConnectingKey", _request);
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        _telegram = d;
        setState(() {});
      } else {
        print(d.error);
      }
    } catch (e) {
      print(e);
    }
  }

  void _socialsDisconnect(int socSite) async {
    Map<String, dynamic> _request = {
      "socialMedia": socSite,
    };
    try {
      final response =
      await _interface.post("Auth/DisconnectSocialMediaAccount", _request);
      var d = Socials.fromJson(response);
      if (d.hasError == false) {
        await _loadDirectives();
        setState(() {});
      } else {
        await _loadDirectives();
        setState(() {});
        Dialogs.openAlertBox(context, AppLocalizations.of(context)!.error, d.error);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Stack(children: [
      Column(children: [
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
                    // _discordAuth();
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
              Text(
                  AppLocalizations.of(context)!
                      .socials_popup
                      .toLowerCase()
                      .capitalize(),
                  style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.social_accounts,
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
                  )
                ])),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(AppLocalizations.of(context)!.socials_info,
              style: const TextStyle(color: Colors.white70)),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
        //   child: Text(AppLocalizations.of(context)!.socials_info, style: TextStyle(color: Colors.white70)),
        // ),
        const SizedBox(
          height: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: SizedBox(
            height: 50.0,
            child: Card(
                elevation: 0,
                color: Colors.black12,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  splashColor: const Color(0xFF1DA1F2),
                  highlightColor: Colors.black54,
                  onTap: ()  {
                    if(!_socials.contains(3)) {
                      _launchURL(_twitter!.data!.url!);
                    }else{
                     Dialogs.openSocDisconnectBox(context, 3, 'Twitter',(soc) =>  _socialsDisconnect(soc));
                    }
                  },
                  // widget.coinSwitch(widget.coin);
                  // widget.activeCoin(widget.coin.coin!);

                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 15.0,
                        ),
                        SizedBox(
                            width: 22.0,
                            child: Image.asset(
                              'images/twitter.png',
                              color: Colors.white70,
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 0.0),
                          child: Text('Twitter',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      fontSize: 18.0, color: Colors.white)),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IgnorePointer(
                            child: NeuButton(
                                height: 28,
                                width: 32,
                                child: RotatedBox(
                                  quarterTurns: 0,
                                  child: Icon(
                                    _socials.contains(3)
                                        ? Icons.check
                                        : Icons.arrow_forward_ios_sharp,
                                    color: Colors.white,
                                    size: 22.0,
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: SizedBox(
            height: 50.0,
            child: Card(
                elevation: 0,
                color: Colors.black12,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  splashColor: const Color(0xFF7289DA),
                  highlightColor: Colors.black54,
                  onTap: () async {
                    if(!_socials.contains(2)) {
                      _launchURL(_telegram!.data!.url!);
                    }else{
                      Dialogs.openSocDisconnectBox(context, 2, 'Telegram', (soc) =>  _socialsDisconnect(soc));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 15.0,
                        ),
                        SizedBox(
                            width: 22.0,
                            child: Image.asset(
                              'images/telegram.png',
                              color: Colors.white70,
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 0.0),
                          child: Text('Telegram',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      fontSize: 18.0, color: Colors.white)),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IgnorePointer(
                            child: NeuButton(
                                height: 28,
                                width: 32,
                                child: RotatedBox(
                                  quarterTurns: 0,
                                  child: Icon(
                                    _socials.contains(2)
                                        ? Icons.check
                                        : Icons.arrow_forward_ios_sharp,
                                    color: Colors.white,
                                    size: 22.0,
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0),
          child: SizedBox(
            height: 50.0,
            child: Card(
                elevation: 0,
                color: Colors.black12,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  splashColor: const Color(0xFF7289DA),
                  highlightColor: Colors.black54,
                  onTap: () async {
                    if(!_socials.contains(1)) {
                      setState(() {
                        _discordDetails
                            ? _discordDetails = false
                            : _discordDetails = true;
                      });
                    }else{
                      Dialogs.openSocDisconnectBox(context, 1, 'Discord',(soc) =>  _socialsDisconnect(soc));
                    }
                    // _launchURL("https://rocketbot.pro/privacy");
                  },
                  // widget.coinSwitch(widget.coin);
                  // widget.activeCoin(widget.coin.coin!);

                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 15.0,
                        ),
                        SizedBox(
                            width: 22.0,
                            child: Image.asset(
                              'images/discord.png',
                              color: Colors.white70,
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 0.0),
                          child: Text('Discord',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      fontSize: 18.0, color: Colors.white)),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: IgnorePointer(
                            child: NeuButton(
                                height: 28,
                                width: 32,
                                child: RotatedBox(
                                  quarterTurns: _socials.contains(1) ? 0 : 1,
                                  child: Icon(
                                    _socials.contains(1)
                                        ? Icons.check
                                        : Icons.arrow_forward_ios_sharp,
                                    color: Colors.white,
                                    size: 22.0,
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _discordDetails ? 1.0 : 0.0,
          child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Color(0xFF7289DA),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _launchURL('https://discord.gg/QJP74zNaJC');
                        },
                        child: Row(
                          children: [
                            Text(
                              '- ' + AppLocalizations.of(context)!.join_discord,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 14.0),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Image.asset(
                              'images/link.png',
                              width: 20.0,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Text(
                            '- ' + AppLocalizations.of(context)!.send_discord,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      // margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      width: double.infinity,
                      height: 30.0,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        color: Color(0xFF252525),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.82,
                              child: AutoSizeTextField(
                                maxLines: 1,
                                minFontSize: 8.0,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white, fontSize: 14.0),
                                autocorrect: false,
                                readOnly: true,
                                controller: _discordTextController,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 4.0, right: 4.0),
                                  isDense: true,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          color: Colors.white54, fontSize: 14.0),
                                  hintText: '',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0, right: 3.0),
                              child: SizedBox(
                                width: 30.0,
                                height: 25.0,
                                child: FlatCustomButton(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: 'connect ' + _discord!.data!.key!));
                                    },
                                    color: const Color(0xFF7289DA),
                                    splashColor: Colors.black38,
                                    child: const Icon(
                                      Icons.content_copy,
                                      size: 18.0,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        )
      ])
    ])));
  }

  void _launchURL(String url) async {
    var _url = url;
    print(_url);
    try {
      await launch(_url);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onDetached() {
    _paused = true;
  }

  @override
  void onInactive() {
    _paused = true;
  }

  @override
  void onPaused() {
      _paused = true;
  }

  @override
  void onResumed() {
    if (_paused) {
      _getUserInfo();
      _paused = false;
    }
  }

  void _getUserInfo() async {
    try {
      final response = await _interface.get("User/Me");
      var d = User.fromJson(response);
      if (d.hasError == false) {
        for (var element in d.data!.socialMediaAccounts!) {
          _socials.add(element.socialMedia!);
        }
        setState(() {});
      } else {
        print(d.error);
      }
    } catch (e) {
      print(e);
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
