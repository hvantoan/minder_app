class AgeHelper {
  static mapAgeToAges(int age) {
    switch (age) {
      case 0:
        return "< 16";
      case 16:
        return "16 - 25";
      case 25:
        return "25 - 35";
      case 35:
        return "> 35";
      default:
        return "> 35";
    }
  }

  static calculate(DateTime? dob) {
    DateTime birthDate = dob ?? DateTime.now();
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
    return age;
  }
}
