import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/ComponentWidgets/nContainer.dart';

class TimeRangeSwitcher extends StatefulWidget {
  final Function(int time) changeTime;
  TimeRangeSwitcher({Key? key, required this.changeTime}) : super(key: key);

  @override
  _TimeRangeSwitcherState createState() => _TimeRangeSwitcherState();
}

class _TimeRangeSwitcherState extends State<TimeRangeSwitcher> {
  var _active = 2;
  var _duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
        child: Row(children: [
      SizedBox(
        width: 35,
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
            child: Text(
              "ALL",
              style:  Theme.of(context).textTheme.subtitle1
            )),),
      ),
      SizedBox(
        width: 35,
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
              "1W",
              style: Theme.of(context).textTheme.subtitle1
            )),),
      ),
      SizedBox(
        width: 30,
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
              child: Text("1D", style: Theme.of(context).textTheme.subtitle1)),
        ),
      ),
      SizedBox(
        width: 35,
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
                "12H",
                style: Theme.of(context).textTheme.subtitle1,
              )),
        ),
      )
    ]));
  }
}
