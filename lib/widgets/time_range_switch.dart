import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeRangeSwitcher extends StatefulWidget {
  final Function(int time) changeTime;
  const TimeRangeSwitcher({Key? key, required this.changeTime}) : super(key: key);

  @override
  _TimeRangeSwitcherState createState() => _TimeRangeSwitcherState();
}

class _TimeRangeSwitcherState extends State<TimeRangeSwitcher> {
  var _active = 2;
  final _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width * 0.12;
    return NeuContainer(
        child: Row(children: [
      SizedBox(
        width: _width,
        child: AnimatedOpacity(
          opacity: _active == 4 ? 1.0 : 0.4,
          duration: _duration,
          child: TextButton(
            onPressed: () {
              setState(() {
                _active = 4;
              });
              widget.changeTime(0);
            },
            child: Text(AppLocalizations.of(context)!.all,
              style:  Theme.of(context).textTheme.subtitle1
            )),),
      ),
      SizedBox(
        width: _width,
        child: AnimatedOpacity(
          opacity: _active == 3 ? 1.0 : 0.4,
          duration: _duration,
          child: TextButton(
            onPressed: () {
              setState(() {
                _active = 3;
              });
              var _time = 24 * 7;
              widget.changeTime(_time);
            },
            child: Text(
                AppLocalizations.of(context)!.onew,
              style: Theme.of(context).textTheme.subtitle1
            )),),
      ),
      SizedBox(
        width: _width,
        child: AnimatedOpacity(
          opacity: _active == 2 ? 1.0 : 0.4,
          duration: _duration,
          child: TextButton(
              onPressed: () {
                setState(() {
                  _active = 2;
                });
                var _time = 24;
                widget.changeTime(_time);
              },
              child: Text(AppLocalizations.of(context)!.oned, style: Theme.of(context).textTheme.subtitle1)),
        ),
      ),
      SizedBox(
        width: _width,
        child: AnimatedOpacity(
          opacity: _active == 1 ? 1.0 : 0.4,
          duration: _duration,
          child: TextButton(
              onPressed: () {
                setState(() {
                  _active = 1;
                });
                widget.changeTime(12);
              },
              child: Text(
                AppLocalizations.of(context)!.twelveh,
                style: Theme.of(context).textTheme.subtitle1,
              )),
        ),
      )
    ]));
  }
}
