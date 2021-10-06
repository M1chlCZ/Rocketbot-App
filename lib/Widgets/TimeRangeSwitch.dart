import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/ComponentWidgets/nContainer.dart';

class TimeRangeSwitcher extends StatefulWidget {
  const TimeRangeSwitcher({Key? key}) : super(key: key);

  @override
  _TimeRangeSwitcherState createState() => _TimeRangeSwitcherState();
}

class _TimeRangeSwitcherState extends State<TimeRangeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return NeuContainer(
        child: Row(children: [
      SizedBox(
        width: 35,
        child: TextButton(
            onPressed: () {},
            child: Text(
              "ALL",
              style: Theme.of(context).textTheme.subtitle1,
            )),
      ),
      SizedBox(
        width: 35,
        child: TextButton(
            onPressed: () {},
            child: Text(
              "1W",
              style: Theme.of(context).textTheme.subtitle1,
            )),
      ),
      SizedBox(
        width: 30,
        child: TextButton(
            onPressed: () {},
            child: Text(
              "1D",
              style: Theme.of(context).textTheme.subtitle1,
            )),
      ),
      SizedBox(
        width: 30,
        child: TextButton(
            onPressed: () {},
            child: Text(
              "1H",
              style: Theme.of(context).textTheme.subtitle1,
            )),
      ),
    ]));
  }
}
