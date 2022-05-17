import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';

class StakeTimeRangeSwitcher extends StatefulWidget {
  final Function(int time) changeTime;
  const StakeTimeRangeSwitcher({Key? key, required this.changeTime}) : super(key: key);

  @override
  StakeTimeRangeSwitcherState createState() => StakeTimeRangeSwitcherState();
}

class StakeTimeRangeSwitcherState extends State<StakeTimeRangeSwitcher> {
  var _active = 1;
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
                    widget.changeTime(3);
                  },
                  child: AutoSizeText('Y',
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
                    widget.changeTime(2);
                  },
                  child: AutoSizeText(
                      'M',
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
                    widget.changeTime(1);
                  },
                  child: AutoSizeText('W',
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
                    widget.changeTime(0);
                  },
                  child: AutoSizeText(
                    'D',
                    minFontSize: 6,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle1,
                  )),
            ),
          )
        ]));
  }
}
