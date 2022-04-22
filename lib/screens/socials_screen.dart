import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/models/socials.dart';
import 'package:rocketbot/netInterface/interface.dart';
import 'package:rocketbot/support/auto_size_text_field.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/life_cycle_watcher.dart';
import 'package:rocketbot/widgets/button_flat.dart';
import 'package:rocketbot/widgets/social_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';

class SocialScreen extends StatefulWidget {
  final List<int> socials;
  final User me;

  const SocialScreen({Key? key, required this.socials, required this.me})
      : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends LifecycleWatcherState<SocialScreen> {
  final NetInterface _interface = NetInterface();
  final TextEditingController _discordTextController = TextEditingController();
  List<int> _socials = [];
  bool _paused = false;
  User? _me;

  Socials? _discord;
  Socials? _twitter;
  Socials? _telegram;

  SocialMediaAccounts? _twitterAccount;
  SocialMediaAccounts? _telegramAccount;
  SocialMediaAccounts? _discordAccount;

  bool _discordDetails = false;

  @override
  void initState() {
    _socials = widget.socials;
    _me = widget.me;
    super.initState();
    _loadDirectives();
    _getAccounts();
  }

  _loadDirectives() async {
    await _loadDiscordDirective();
    await _loadTwitterDirective();
    await _loadTelegramDirective();
  }

  _getUserInfo() async {
    try {
      final response = await _interface.get("User/Me");
      var d = User.fromJson(response);
      _twitterAccount = null;
      _telegramAccount = null;
      _discordAccount = null;
      if (d.hasError == false) {
        _socials.clear();
        _me = d;
        for (var element in d.data!.socialMediaAccounts!) {
          _socials.add(element.socialMedia!);
        }
        await _getAccounts();
        setState(() {});
      } else {
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _getAccounts() async {
    try {
      _twitterAccount = _me!.data!.socialMediaAccounts
          ?.firstWhere((element) => element.socialMedia == 3);
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _telegramAccount = _me!.data!.socialMediaAccounts
          ?.firstWhere((element) => element.socialMedia == 2);
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _discordAccount = _me!.data!.socialMediaAccounts
          ?.firstWhere((element) => element.socialMedia == 1);
    } catch (e) {
      debugPrint(e.toString());
    }
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
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
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
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
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
        debugPrint(d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
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
        Future.delayed(const Duration(seconds: 2), () async {
          _socials.clear();
          await _loadDirectives();
          await _getUserInfo();
          setState(() {});
        });
      } else {
        await _loadDirectives();
        setState(() {});
        Dialogs.openAlertBox(
            context, AppLocalizations.of(context)!.error, d.error);
      }
    } catch (e) {
      debugPrint(e.toString());
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
        const SizedBox(
          height: 30.0,
        ),
        SocialMediaCard(
          name: 'Twitter',
          cardActiveColor: const Color(0xFF1DA1F2),
          pictureName: 'images/twitter.png',
          onTap: () async {
            if (!_socials.contains(3)) {
              await _loadTwitterDirective();
              _launchURL(_twitter!.data!.url!);
              }
          },
          unlink: _socialsDisconnect,
          socials: _twitterAccount,
        ),
        const SizedBox(
          height: 10.0,
        ),
        SocialMediaCard(
          name: 'Telegram',
          cardActiveColor: const Color(0xFF229ED9),
          pictureName: 'images/telegram.png',
          onTap: () async {
            if (!_socials.contains(2)) {
              await _loadTelegramDirective();
              _launchURL(_telegram!.data!.url!);
            }
          },
          socials: _telegramAccount,
          unlink: _socialsDisconnect,
        ),
        const SizedBox(
          height: 10.0,
        ),
        SocialMediaCard(
          name: 'Discord',
          cardActiveColor: const Color(0xFF7289DA),
          pictureName: 'images/discord.png',
          onTap: () async {
            if (!_socials.contains(1)) {
              await _loadDiscordDirective();
              setState(() {
                _discordDetails
                    ? _discordDetails = false
                    : _discordDetails = true;
              });
            }
          },
          unlink: _socialsDisconnect,
          socials: _discordAccount,
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
                                          color: Colors.white54,
                                          fontSize: 14.0),
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
                              padding:
                                  const EdgeInsets.only(top: 0.0, right: 3.0),
                              child: SizedBox(
                                width: 30.0,
                                height: 25.0,
                                child: FlatCustomButton(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: 'connect ' +
                                              _discord!.data!.key!));
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
    var _url = url.replaceAll(" ", "+");
    // print(_url);
    try {
      await launch(_url);
    } catch (e) {
      debugPrint(e.toString());
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
  void onResumed() async {
    if (_paused) {
      _getUserInfo();
      _paused = false;
    }
  }


}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
