import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';

class LoginRegisterSwitcher extends StatefulWidget {
  final Function(int time)? changeType;
  const LoginRegisterSwitcher({Key? key, this.changeType}) : super(key: key);

  @override
  _LoginRegisterSwitcherState createState() => _LoginRegisterSwitcherState();
}

class _LoginRegisterSwitcherState extends State<LoginRegisterSwitcher> {
  var _active = 0;
  final _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: NeuContainer(
          child: Row(children: [
        SizedBox(
          width: 100,
          child: AnimatedOpacity(
            opacity: _active == 0 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _active = 4;
                });
                widget.changeType!(0);
              },
              child: Text(
                "LOGIN",
                style:  Theme.of(context).textTheme.headline4!
              )),),
        ),
        Text('|',
          style: Theme.of(context).textTheme.headline4!),
        SizedBox(
          width: 100,
          child: AnimatedOpacity(
            opacity: _active == 1 ? 1.0 : 0.4,
            duration: _duration,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _active = 3;
                });
                var _time = 24 * 7;
                widget.changeType!(1);
              },
              child: Text(
                "REGISTER",
                style: Theme.of(context).textTheme.headline4
              )),),
        ),

      ])),
    );
  }
}
