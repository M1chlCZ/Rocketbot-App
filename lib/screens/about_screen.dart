import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/support/gradient_text.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
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
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      AppLocalizations.of(context)!.about.toUpperCase() + " ROCKETBOT",
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
                        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin malesuada urna diam tristique aenean. Sed dui in id dui ornare nunc, id,\n',
                        style: Theme.of(context).textTheme.headline4,
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin malesuada urna diam tristique aenean. Sed dui in id dui ornare nunc, id,',
                              style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ],)
        ],),
      ),
    );
  }
}
