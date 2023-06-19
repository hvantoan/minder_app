import 'package:flutter/material.dart';
import 'package:minder/domain/entity/match/match.dart' as match;
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_text_style.dart';

class MatchHelper {
  static mapStatusToText(match.Match match, String myTeamId) {
    switch (match.status) {
      case 1:
        final host = match.hostTeam!.teamId == myTeamId
            ? match.hostTeam
            : match.opposingTeam;
        if (host?.hasConfirm ?? false) {
          return Text(
            S.current.txt_wait_member_confirm,
            style: BaseTextStyle.body1(color: BaseColor.green500),
          );
        }
        return Text(S.current.txt_setting_up,
            style: BaseTextStyle.body1(color: BaseColor.blue500));
      case 2:
        final host = match.hostTeam!.teamId == myTeamId
            ? match.hostTeam
            : match.opposingTeam;
        if (!(host!.hasConfirm ?? false)) {
          return Text(S.current.txt_setting_up,
              style: BaseTextStyle.body1(color: BaseColor.blue500));
        }
        return Text(
          S.current.txt_wait_member_confirm,
          style: BaseTextStyle.body1(color: BaseColor.green500),
        );
        final state = calculateTime(match.hostTeam!.date.toString());
        if (state == 0) {
          return Text(S.current.txt_playing,
              style: BaseTextStyle.body1(color: BaseColor.green500));
        }
        if (state == 1) {
          return Text(getTime(match.hostTeam!.date.toString()),
              style: BaseTextStyle.body1(color: BaseColor.green500));
        }
        return Text(S.current.txt_finished,
            style: BaseTextStyle.body1(color: BaseColor.grey500));
      case 3:
        return Text(S.current.txt_canceled,
            style: BaseTextStyle.body1(color: BaseColor.grey300));
      default:
        return const SizedBox.shrink();
    }
  }

  static int calculateTime(String selectedDate) {
    final DateTime date = DateTime.parse(selectedDate);
    final DateTime now = DateTime.now();
    int difference = date.difference(now).inDays;
    if (difference == 0) {
      difference = date.difference(now).inHours;
      if (difference == 0) {
        return 0;
      }
      if (difference >= 1) {
        return 1;
      }
      return -1;
    }
    if (difference >= 1) {
      return 1;
    }
    return -1;
  }

  static getTime(String selectedDate) {
    final DateTime date = DateTime.parse(selectedDate);
    final DateTime now = DateTime.now();
    int difference = date.difference(now).inDays;
    if (difference < 1) {
      difference = date.difference(now).inHours;
      if (difference < 1) {
        difference = date.difference(now).inMinutes;
        return "$difference ${difference > 1 ? S.current.txt_more_minutes : S.current.txt_more_minute}";
      }
      return "$difference ${difference > 1 ? S.current.txt_more_hours : S.current.txt_more_hour}";
    }
    return "$difference ${difference > 1 ? S.current.txt_more_days : S.current.txt_more_day}";
  }
}
