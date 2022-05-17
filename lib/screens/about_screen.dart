import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Material(
        child: SafeArea(
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Text(AppLocalizations.of(context)!.about,
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        "${AppLocalizations.of(context)!.about.toUpperCase()} ROCKETBOT",
                        gradient: const LinearGradient(colors: [
                          Color(0xFFF05523),
                          Color(0xFF812D88),
                        ]),
                        align: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                            fontSize: 14.0, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(height: 0.5, color: Colors.white12,),
                      const SizedBox(
                        height: 20.0,
                      ),
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!.about_rocket,
                          style: Theme.of(context).textTheme.headline4,
                          children: <TextSpan>[
                            TextSpan(
                                text: '',
                                style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      )
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
                      SizedBox(
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
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                _launchURL("https://rocketbot.pro/terms");
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .about_terms,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            _launchURL("https://rocketbot.pro/terms");
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
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
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                _launchURL("https://rocketbot.pro/privacy");
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .about_policy,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            _launchURL("https://rocketbot.pro/privacy");
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
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
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                _launchURL("https://rocketbot.pro/");
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .about_visit,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            _launchURL("https://rocketbot.pro/");
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
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
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                _launchURL("https://projectmerge.org/");
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .about_merge,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            _launchURL("https://projectmerge.org/");
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        AppLocalizations.of(context)!.about_devs.toUpperCase(),
                        gradient: const LinearGradient(colors: [
                          Color(0xFFF05523),
                          Color(0xFF812D88),
                        ]),
                        align: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                            fontSize: 14.0, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(height: 0.5, color: Colors.white12,),
                      const SizedBox(
                        height: 20.0,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Project lead: \n",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Row(children: [
                        const SizedBox(width: 20.0,),
                        Text("Jon DFWplay", style: Theme.of(context).textTheme.headline4,),
                        const Expanded(child: SizedBox()),
                        NeuButton(
                          width: 25,
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset("images/linked.png", color: Colors.white70),
                          ),
                          onTap: () {
                            _launchURL("https://www.linkedin.com/in/jonathan-astie-2054201/");
                          },
                        ),
      const SizedBox(
        width: 20.0,
      ),
                        NeuButton(
                          width: 25,
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset("images/twitter.png", color: Colors.white70),
                          ),
                          onTap: () {
                            _launchURL("https://twitter.com/DfWplay");
                          },
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        NeuButton(
                          width: 25,
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset("images/email.png", color: Colors.white70,),
                          ),
                          onTap: () {
                            _launchURL("mailto:dfwplay@gmail.com");
                          },
                        ),
                      ],),
                      const SizedBox(
                        height: 20.0,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "APP dev: \n",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Row(children: [
                        const SizedBox(width: 20.0,),
                        Text("Michal Žídek", style: Theme.of(context).textTheme.headline4,),
                        const Expanded(child: SizedBox()),
                        NeuButton(
                          width: 25,
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset("images/telegram.png", color: Colors.white70),
                          ),
                          onTap: () {
                            _launchURL("https://t.me/m1chlcz");
                          },
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        NeuButton(
                          width: 25,
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset("images/twitter.png", color: Colors.white70),
                          ),
                          onTap: () {
                            _launchURL("https://twitter.com/m1chl");
                          },
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        NeuButton(
                          width: 25,
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset("images/email.png", color: Colors.white70,),
                          ),
                          onTap: () {
                            _launchURL("mailto:m1chl@centrum.cz");
                          },
                        ),
                      ],),
                      const SizedBox(height: 10.0,),
                      const SizedBox(
                        height: 20.0,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Rocketbot API + WEB dev: \n\n",
                          style: Theme.of(context).textTheme.headline4,
                          children: <TextSpan>[
                            TextSpan(
                              text: '      Bohdan Shamro',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
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
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                _launchURL("https://mergebcdg.com/");
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .about_develop,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            _launchURL("https://mergebcdg.com/");
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
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
                              splashColor: Colors.black54,
                              highlightColor: Colors.black54,
                              onTap: () async {
                                showLicense(context);
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .about_licences,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 10.0),
                                      child: NeuButton(
                                          height: 25,
                                          width: 20,
                                          onTap: () async {
                                            showLicense(context);
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            color: Colors.white,
                                            size: 22.0,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
            ],)
          ],),
        ),
      ),
    );
  }

  showLicense(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).canvasColor,
            cardColor: Theme.of(context).canvasColor,
            textTheme: TextTheme(
                headline1: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 28.0,
                ),
                headline2: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
                headline3: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
                headline4: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
                subtitle1: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 10.0,
                ),
                subtitle2: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontWeight: FontWeight.w400,
                    fontSize: 10.0,
                    fontStyle: FontStyle.italic
                ),
                bodyText1: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                bodyText2: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                )
            ),
            primaryTextTheme: Theme.of(context).textTheme,
            appBarTheme: Theme.of(context).appBarTheme.copyWith(color: Theme.of(context).canvasColor),

          ),
          child: LicensePage(
            applicationVersion: _packageInfo!.version,
            applicationIcon: Image.asset('images/logo_big.png', width: 150,),
            applicationLegalese: 'Legal stuff',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  void _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  void _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
