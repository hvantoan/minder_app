import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/enum/weekday_enum.dart';

class WeekdayHelper {
  static String mapKeyToTitle(Weekday weekday) {
    switch (weekday) {
      case Weekday.monday:
        return S.current.txt_monday;
      case Weekday.tuesday:
        return S.current.txt_tuesday;
      case Weekday.wednesday:
        return S.current.txt_wednesday;
      case Weekday.thursday:
        return S.current.txt_thursday;
      case Weekday.friday:
        return S.current.txt_friday;
      case Weekday.saturday:
        return S.current.txt_saturday;
      case Weekday.sunday:
        return S.current.txt_sunday;
      default:
        return "";
    }
  }
}
