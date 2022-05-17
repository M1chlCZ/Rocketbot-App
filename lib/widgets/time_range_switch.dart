import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeRangeSwitcher extends StatefulWidget {
  final Function(int time) changeTime;
  const TimeRangeSwitcher({Key? key, required this.changeTime}) : super(key: key);

  @override
  TimeRangeSwitcherState createState() => TimeRangeSwitcherState();
}

class TimeRangeSwitcherState extends State<TimeRangeSwitcher> {
  var _active = 2;
  final _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.12;
    return NeuContainer(
        child: Row(children: [
      SizedBox(
        width: width,
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
            child: AutoSizeText(AppLocalizations.of(context)!.all,
              minFontSize: 6,
              maxLines: 1,
              style:  Theme.of(context).textTheme.subtitle1
            )),),
      ),
      SizedBox(
        width: width,
        child: AnimatedOpacity(
          opacity: _active == 3 ? 1.0 : 0.4,
          duration: _duration,
          child: TextButton(
            onPressed: () {
              setState(() {
                _active = 3;
              });
              var time = 24 * 7;
              widget.changeTime(time);
            },
            child: AutoSizeText(
                AppLocalizations.of(context)!.onew,
                minFontSize: 6,
                maxLines: 1,
              style: Theme.of(context).textTheme.subtitle1
            )),),
      ),
      SizedBox(
        width: width,
        child: AnimatedOpacity(
          opacity: _active == 2 ? 1.0 : 0.4,
          duration: _duration,
          child: TextButton(
              onPressed: () {
                setState(() {
                  _active = 2;
                });
                var time = 24;
                widget.changeTime(time);
              },
              child: AutoSizeText(AppLocalizations.of(context)!.oned,
                  minFontSize: 6,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle1)),
        ),
      ),
      SizedBox(
        width: width,
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
              child: AutoSizeText(
                AppLocalizations.of(context)!.twelveh,
                minFontSize: 6,
                maxLines: 1,
                style: Theme.of(context).textTheme.subtitle1,
              )),
        ),
      )
    ]));
  }
}
