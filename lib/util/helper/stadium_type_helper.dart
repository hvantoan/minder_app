import 'package:minder/util/constant/enum/stadium_type_enum.dart';

class StadiumTypeHelper {
  static int mapEnumToInt({required StadiumType stadiumType}) {
    switch (stadiumType) {
      case StadiumType.five:
        return 5;
      case StadiumType.seven:
        return 7;
      case StadiumType.eleven:
        return 11;
      default:
        return 5;
    }
  }

  static StadiumType mapIntToEnum({required int type}) {
    switch (type) {
      case 5:
        return StadiumType.five;
      case 7:
        return StadiumType.seven;
      case 11:
        return StadiumType.eleven;
      default:
        return StadiumType.five;
    }
  }
}
