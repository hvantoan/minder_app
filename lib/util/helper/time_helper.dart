import 'package:flutter/cupertino.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/style/base_text_style.dart';

class TimeHelper {
  static mapTimeToTimes(int time) {
    switch (time) {
      case 0:
        return "12AM - 06AM";
      case 6:
        return "06AM - 12PM";
      case 12:
        return "12PM - 06PM";
      case 18:
        return "06PM - 12AM";
      default:
        return "12AM - 06AM";
    }
  }

  static mapTimeToWidget(GameTime gameTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (gameTime.monday != null && gameTime.monday!.isNotEmpty)
          Text(
            "${S.current.txt_monday}, ${S.current.txt_at} ${gameTime.monday!.map((e) => "${e.toInt()}:00").join(", ")}",
            style: BaseTextStyle.body1(),
          ),
        if (gameTime.tuesday != null && gameTime.tuesday!.isNotEmpty)
          Text(
            "${S.current.txt_tuesday}, ${S.current.txt_at} ${gameTime.tuesday!.map((e) => "${e.toInt()}:00").join(", ")}",
            style: BaseTextStyle.body1(),
          ),
        if (gameTime.wednesday != null && gameTime.wednesday!.isNotEmpty)
          Text(
            "${S.current.txt_wednesday}, ${S.current.txt_at} ${gameTime.wednesday!.map((e) => "${e.toInt()}:00").join(", ")}",
            style: BaseTextStyle.body1(),
          ),
        if (gameTime.thursday != null && gameTime.thursday!.isNotEmpty)
          Text(
            "${S.current.txt_thursday}, ${S.current.txt_at} ${gameTime.thursday!.map((e) => "${e.toInt()}:00").join(", ")}",
            style: BaseTextStyle.body1(),
          ),
        if (gameTime.friday != null && gameTime.friday!.isNotEmpty)
          Text(
            "${S.current.txt_friday}, ${S.current.txt_at} ${gameTime.friday!.map((e) => "${e.toInt()}:00").join(", ")}",
            style: BaseTextStyle.body1(),
          ),
        if (gameTime.saturday != null && gameTime.saturday!.isNotEmpty)
          Text(
            "${S.current.txt_saturday}, ${S.current.txt_at} ${gameTime.saturday!.map((e) => "${e.toInt()}:00").join(", ")}",
            style: BaseTextStyle.body1(),
          ),
        if (gameTime.sunday != null && gameTime.sunday!.isNotEmpty)
          Text(
            "${S.current.txt_sunday}, ${S.current.txt_at} ${gameTime.sunday!.map((e) => "${e.toInt()}:00").join(", ")}",
            style: BaseTextStyle.body1(),
          ),
      ],
    );
  }

  static String formatDate(String date) {
    String y = date.substring(0, 4);
    String m = date.substring(5, 7);
    String d = date.substring(8, 10);

    return "$d/$m/$y";
  }
}
