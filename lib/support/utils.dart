import 'package:intl/intl.dart';

class Utils {
  static String getUTC() {
    var dateTime = DateTime.now();
    var _date = DateFormat('yyyy-MM-dd').format(dateTime);
    var _dateZero = _date + " 00:00:00";
    var val = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
        .format(DateTime.parse(_dateZero));
    var offset = dateTime.timeZoneOffset;
    var hours =
    offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0
    if (!offset.isNegative) {
      val = val +
          "+" +
          offset.inHours.toString().padLeft(2, '0') +
          ":" +
          (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
    } else {
      val = val +
          "-" +
          (-offset.inHours).toString().padLeft(2, '0') +
          ":" +
          (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
    }
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(val));
  }
}