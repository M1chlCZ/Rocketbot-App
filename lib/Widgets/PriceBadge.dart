import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PriceBadge extends StatelessWidget {
  final double percentage;
  const PriceBadge({Key? key, required this.percentage}) : super(key: key);

  String _getNum(double num) {
    if(num > 0) {
      return num.toStringAsFixed(2);
    }else{
      return (num * - 1).toStringAsFixed(2);
    }
  }

  double? _getWidth(double num) {
    if(num < 0) {
      num = num * -1.0;
    }

    if(num < 10) {
      return 55.0;
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
      width: _getWidth(percentage),
      child: Container(
          decoration: BoxDecoration(
            color: percentage > 0 ? Color(0x1A1AD37A) : Color(0xEB3912).withOpacity(0.1),
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 3.0, bottom: 2.0, right: 3.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                    child: SvgPicture.string( percentage > 0 ? arrowUP : arrowDown)),
                SizedBox(width: 2.0,),
                Text(_getNum(percentage) + "%", style: TextStyle (
                  color: percentage > 0 ? Color(0xFF1AD37A) : Color(0xFFEB3912),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0,))
              ],
            ),
          )),
    );
  }
}


String arrowUP = '''<svg width="9" height="9" viewBox="0 0 9 9" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M2.66914 5.75487C2.48165 6.08817 2.72251 6.5 3.10492 6.5L5.89508 6.5C6.27749 6.5 6.51835 6.08817 6.33086 5.75487L4.93579 3.27473C4.74464 2.93491 4.25536 2.93491 4.06421 3.27473L2.66914 5.75487Z" fill="#1AD37A"/>
</svg>''';

String arrowDown = '''
<svg width="9" height="9" viewBox="0 0 5 4" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M4.08086 1.24513C4.26835 0.911829 4.02749 0.5 3.64508 0.5L0.854923 0.5C0.47251 0.5 0.231653 0.911828 0.419136 1.24513L1.81421 3.72527C2.00536 4.06509 2.49464 4.06509 2.68579 3.72527L4.08086 1.24513Z" fill="#EB3912"/>
</svg>

''';
