import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/enum/gender_enum.dart';

class GenderHelper {
  static String mapKeyToName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return S.current.txt_male;
      case Gender.female:
        return S.current.txt_female;
      default:
        return S.current.txt_different;
    }
  }
}
