import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PriceBadge extends StatefulWidget {
  final Decimal? percentage;
  const PriceBadge({Key? key, required this.percentage}) : super(key: key);

  @override
  State<PriceBadge> createState() => _PriceBadgeState();
}

class _PriceBadgeState extends State<PriceBadge> {

  double _perc = 0.0;
  @override
  void initState() {
    super.initState();
    if (widget.percentage != null) {
      _perc = widget.percentage!.toDouble();
    }else{
      print("null");
    }
  }
  
  String _getNum(double num) {
    if(num > 0) {
      return "+" + num.toStringAsFixed(2);
    }else{
      return (num).toStringAsFixed(2);
    }
  }

  double? _getWidth(double num) {
    if(num < 0) {
      num = num * -1.0;
    }

    if(num < 10) {
      return 60.0;
    }else if(num < 100) {
      return 60.0;
    }else if(num < 1000){
      return 75.0;
    }else{
      return 85.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(_perc),
      child: Container(
          decoration: BoxDecoration(
            color: _perc > 0 ? const Color(0x1A1AD37A) : const Color(0xEB3912).withOpacity(0.1),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 6.0, bottom: 2.0, right: 6.0),
              child:
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
                  // SizedBox(
                  //   height: 15,
                  //     child: SvgPicture.string( _perc > 0 ? arrowUP : arrowDown)),
                  // const SizedBox(width: 3.0,),
                  AutoSizeText(_getNum(_perc) + "%",
                      minFontSize: 8.0,
                      maxLines: 1,
                      style: TextStyle (
                    color: _perc > 0 ? const Color(0xFF1AD37A) : const Color(0xFFEB3912),
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,))
                // ],
              // ),
            ),
          )),
    );
  }


}


String arrowUP = '''
<svg width="9" height="9" viewBox="0 0 5 5" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0.669136 3.75487C0.481654 4.08817 0.722511 4.5 1.10492 4.5L3.89508 4.5C4.27749 4.5 4.51835 4.08817 4.33086 3.75487L2.93579 1.27473C2.74464 0.934908 2.25536 0.934908 2.06421 1.27473L0.669136 3.75487Z" fill="#1AD37A"/>
</svg>''';

String arrowDown = '''
<svg width="9" height="9" viewBox="0 0 5 4" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.08086 1.24513C4.26835 0.911829 4.02749 0.5 3.64508 0.5L0.854923 0.5C0.47251 0.5 0.231653 0.911828 0.419136 1.24513L1.81421 3.72527C2.00536 4.06509 2.49464 4.06509 2.68579 3.72527L4.08086 1.24513Z" fill="#EB3912"/>
</svg>

''';
