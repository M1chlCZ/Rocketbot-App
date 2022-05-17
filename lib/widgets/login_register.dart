import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginRegisterSwitcher extends StatefulWidget {
  final Function(int time)? changeType;

  const LoginRegisterSwitcher({Key? key, this.changeType}) : super(key: key);

  @override
  LoginRegisterSwitcherState createState() => LoginRegisterSwitcherState();
}

class LoginRegisterSwitcherState extends State<LoginRegisterSwitcher> {
  var _active = 0;
  final _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: NeuContainer(
          child: Row(children: [
        SizedBox(
          width: 120,
          child: AnimatedOpacity(
            opacity: _active == 0 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    _active = 0;
                  });
                  widget.changeType!(0);
                },
                child: SizedBox(
                  width: 120,
                  child: AutoSizeText(AppLocalizations.of(context)!.login.toUpperCase(),
                       maxLines: 1,
                      minFontSize: 8.0,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.bold)),
                )),
          ),
        ),
        Text('|', style: Theme.of(context).textTheme.headline4!),
        SizedBox(
          width: 120,
          child: AnimatedOpacity(
            opacity: _active == 1 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    _active = 1;
                  });
                  widget.changeType!(1);
                },
                child: SizedBox(
                  width: 120,
                  child: AutoSizeText(AppLocalizations.of(context)!.register.toUpperCase(),
                      maxLines: 1,
                      minFontSize: 8.0,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.bold)),
                )),
          ),
        ),
      ])),
    );
  }
}
