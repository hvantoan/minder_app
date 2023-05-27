import 'package:minder/util/constant/enum/gender_enum.dart';

class UserHelper {
  static Gender mapNumToEnum(num sex) {
    if (sex.toInt() == 0) {
      return Gender.male;
    }
    if (sex.toInt() == 1) {
      return Gender.female;
    }
    return Gender.different;
  }
}
