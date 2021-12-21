import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CoinPriceGraph extends StatefulWidget {
  final HistoryPrices? prices;
  final int? time;
  final Function (bool touch) blockTouch;

  const CoinPriceGraph({Key? key, this.prices, this.time, required this.blockTouch}) : super(key: key);

  @override
  CoinPriceGraphState createState() => CoinPriceGraphState();
}

class CoinPriceGraphState extends State<CoinPriceGraph> {
  double _divider = 0.1;
  final int _leftLabelsCount = 6;
  var _time = 24;
  HistoryPrices? _price;

  final List<FlSpot> _values = [];

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _leftTitlesInterval = 0;

  @override
  void initState() {
    super.initState();
    _price = widget.prices;
    _preparePriceData(24);
  }

  void changeTime(int time) {
    setState(() {
      _values.clear();
    });
    _time = time;
    _preparePriceData(time);
  }

  void changeCoin(HistoryPrices h) {
    setState(() {
      _values.clear();
    });
    _price = h;
    _preparePriceData(_time);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _preparePriceData(int timeInHours) async {
    try {
      double minY = double.maxFinite;
      double maxY = double.minPositive;

      var timeNow = DateTime.now().millisecondsSinceEpoch;
      var hourAgo = 0;

      if (timeInHours != 0) {
            hourAgo = timeNow - 3600000 * timeInHours;
          } else {
            hourAgo = 0;
          }

      for (List<double> data in _price!.usd!) {
            if (data[0] >= hourAgo) {
              if (minY > data[1]) minY = data[1];
              if (maxY < data[1]) maxY = data[1];
              var _spot = FlSpot(data[0].toDouble(), data[1]);
              _values.add(_spot);
            }
          }

      _minX = _values.first.x;
      _maxX = _values.last.x;

      _divider = maxY /100;

      _minY = (minY / _divider).floorToDouble() * _divider;
      _maxY = (maxY / _divider).ceilToDouble() * _divider;


      _leftTitlesInterval =
              ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

      setState(() {});
    } catch (e) {
      _values.clear();
      print(e);
    }
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: _gridData(),
      titlesData: FlTitlesData(
          bottomTitles: _bottomTitles(),
          leftTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false)),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.white12, width: 1),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineTouchData: LineTouchData(
        touchCallback: (FlTouchEvent? event, LineTouchResponse? touchResponse) {
          if (event is FlTapDownEvent ||
              event is FlPointerHoverEvent ||
              event is FlPanDownEvent) {
              widget.blockTouch(true);
          } else if (event is FlLongPressEnd || event is FlTapUpEvent) {
              widget.blockTouch(false);
          } else if (event is FlTapCancelEvent) {
              widget.blockTouch(false);
          } else if (event is FlPanStartEvent ||
              event is FlLongPressMoveUpdate) {
              widget.blockTouch(true);
          } else if (event is FlPanEndEvent ||
              event is FlPanCancelEvent) {
              widget.blockTouch(false);
          }
        },
          touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipRoundedRadius: 4,
              tooltipBgColor: Colors.black54,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  return LineTooltipItem(
                    '',
                    Theme.of(context).textTheme.subtitle1!,
                    children: [
                      TextSpan(
                        text: flSpot.y.toStringAsFixed(3) + " USD",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  );
                }).toList();
              }),
          enabled: true),
      lineBarsData: [_lineBarData()],
    );
  }

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: _values,
      colors: [const Color(0xFF257DC1)],
      barWidth: 1,
      shadow: const Shadow(
          color: Color(0xFF257DC1),
          blurRadius: 5.0,
          offset: Offset(0.5, 1)),
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        colors: _gradientColors,
        gradientColorStops: const [0.0, 0.8, 1.0],
        gradientFrom: const Offset(0.0, 0),
        gradientTo: const Offset(0.0, 1),
      ),
    );
  }

  // SideTitles _leftTitles() {
  //   return SideTitles(
  //     showTitles: true,
  //     getTextStyles: (context, value) {
  //       return TextStyle(
  //         color: Colors.white54,
  //         fontSize: 14,
  //       );
  //     },
  //     getTitles: (value) =>
  //         NumberFormat.compactCurrency(symbol: '\$').format(value),
  //     reservedSize: 28,
  //     margin: 12,
  //     interval: _leftTitlesInterval,
  //   );
  // }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (context, value) {
        return Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Colors.white.withOpacity(0.2));
      },
      getTitles: (value) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        if (_time == 24 * 7 || _time == 0) {
          return DateFormat.yMd().format(date);
        } else {
          return DateFormat.Hm().format(date);
        }
      },
      margin: 8,
      interval: (_maxX - _minX) / 8,
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      show: false,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _minY) % _leftTitlesInterval == 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 0.0, left: 0.0, top: 10, bottom: 10),
      child: _values.isEmpty
          ? Container( color: Colors.transparent, child: Center(child: Padding(
            padding: const EdgeInsets.only(top: 130.0),
            child: Text(AppLocalizations.of(context)!.graph_no_data, style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white24), ),
          )),)
          : LineChart(
              _mainData(),
              swapAnimationDuration: const Duration(milliseconds: 300),
              swapAnimationCurve: Curves.linearToEaseOut,
            ),
    );
  }
}

final List<Color> _gradientColors = [
  const Color.fromRGBO(37, 125, 193, 0.1),
  const Color.fromRGBO(196, 196, 196, 0),
  const Color.fromRGBO(255, 255, 255, 0),
];
