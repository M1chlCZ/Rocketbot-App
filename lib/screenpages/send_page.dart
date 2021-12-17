import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 40.0, top: 10.0, bottom: 0.0),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.send,
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(
                      width: 50,
                    ),
                    // SizedBox(
                    //     height: 30,
                    //     child: TimeRangeSwitcher(
                    //       changeTime: _changeTime,
                    //     )),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            height: 30,
                            width: 25,
                            child: NeuButton(
                              onTap: () async {

                                // await const FlutterSecureStorage().delete(key: "token");
                                // Navigator.of(context).pushReplacement(
                                //     PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
                                //       return const LoginScreen();
                                //     }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                                //       return FadeTransition(opacity: animation, child: child);
                                //     }));
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
