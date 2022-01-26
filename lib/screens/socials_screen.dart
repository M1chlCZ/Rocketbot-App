import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/support/social_auth.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  DiscordAuthClient? _discordAuthClient;
  AccessTokenResponse? _discordResponse;

  @override
  void initState() {
    super.initState();
    _discordAuthClient = DiscordAuthClient();
  }

  _discordAuth() async {
    _discordResponse = await _discordAuthClient!.getTokenWithAuthCodeFlow(
        clientId: '866463128442896384', clientSecret: 'xU7O5qE4NdqR7XiWhhA6tYh2qwh-brru', scopes: ['identify']);
    print(_discordResponse!.accessToken);
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
                    // Navigator.of(context).pop();
                    _discordAuth();
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
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                  )
                ]))
      ])
    ])));
  }
}
