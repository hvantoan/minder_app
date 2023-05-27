import 'package:minder/generated/l10n.dart';

class StringHelper {
  static String createNameKey(String name) {
    if (name.isEmpty) return "";
    String result = name[0];
    for (int i = 0; i < name.length - 1; i++) {
      if (name[i] == " " && name[i + 1] != " ") result += name[i + 1];
    }
    if (result.length > 2) result = result.substring(0, 2);
    return result.toUpperCase();
  }

  static String defineStadiumType(List<num>? gameType) {
    String stadiumTypeString = "";
    if (gameType != null) {
      for (var element in gameType) {
        stadiumTypeString += element.toString();
        if (element != gameType.last) {
          stadiumTypeString += "/";
        }
      }
    }
    return stadiumTypeString;
  }

  static String calculateAge(DateTime? dayOfBirth) {
    DateTime birthDate = dayOfBirth ?? DateTime.now();
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return "$age ${S.current.txt_years_old}";
  }
}
