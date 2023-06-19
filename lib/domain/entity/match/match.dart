import 'package:minder/data/model/match/match_model.dart';
import 'package:minder/domain/entity/stadium/stadium.dart';

class Match {
  String? id;
  String? hostTeamId;
  String? opposingTeamId;
  int? status;
  String? selectedDate;
  int? teamSide;
  MatchTeam? hostTeam;
  MatchTeam? opposingTeam;
  List<TimeChoice>? timeChoices;

  Match(
      this.id,
      this.hostTeamId,
      this.opposingTeamId,
      this.status,
      this.selectedDate,
      this.teamSide,
      this.hostTeam,
      this.opposingTeam,
      this.timeChoices);

  Match.fromModel(MatchModel matchModel) {
    id = matchModel.id;
    hostTeamId = matchModel.hostTeamId;
    opposingTeamId = matchModel.opposingTeamId;
    status = matchModel.status;
    selectedDate = matchModel.selectedDate;
    teamSide = matchModel.teamSide;
    hostTeam = matchModel.hostTeam != null
        ? MatchTeam.fromModel(matchModel.hostTeam!)
        : null;
    opposingTeam = matchModel.opposingTeam != null
        ? MatchTeam.fromModel(matchModel.opposingTeam!)
        : null;
    timeChoices =
        matchModel.timeChoices!.map((e) => TimeChoice.fromModel(e)).toList();
  }
}

class MatchTeam {
  String? id;
  String? teamId;
  String? stadiumId;
  num? selectedDayOfWeek;
  num? from;
  num? to;
  DateTime? date;
  String? hostMatch;
  String? opposingMatch;
  Stadium? stadium;
  String? teamName;
  String? avatar;
  double? latitude;
  double? longitude;

  MatchTeam(
      this.id,
      this.teamId,
      this.stadiumId,
      this.selectedDayOfWeek,
      this.from,
      this.to,
      this.date,
      this.hostMatch,
      this.opposingMatch,
      this.stadium,
      this.teamName,
      this.avatar,
      this.latitude,
      this.longitude);

  MatchTeam.fromModel(MatchTeamModel matchTeamModel) {
    id = matchTeamModel.id;
    teamId = matchTeamModel.teamId;
    stadiumId = matchTeamModel.stadiumId;
    selectedDayOfWeek = matchTeamModel.selectedDayOfWeek;
    from = matchTeamModel.from;
    to = matchTeamModel.to;
    date = matchTeamModel.date;
    stadium = matchTeamModel.stadium != null
        ? Stadium.fromModel(matchTeamModel.stadium!)
        : null;
    teamName = matchTeamModel.teamName;
    avatar = matchTeamModel.avatar;
    latitude = matchTeamModel.latitude;
    longitude = matchTeamModel.longitude;
  }
}

class TimeChoice {
  num? dayOfWeek;
  String? displayDay;
  DateTime? date;
  List<TimeOption>? options;

  TimeChoice(this.dayOfWeek, this.displayDay, this.date, this.options);

  TimeChoice.fromModel(TimeChoiceModel timeChoiceModel) {
    dayOfWeek = timeChoiceModel.dayOfWeek;
    displayDay = timeChoiceModel.displayDay;
    date = timeChoiceModel.date;
    options =
        timeChoiceModel.options!.map((e) => TimeOption.fromModel(e)).toList();
  }
}

class TimeOption {
  num? from;
  num? to;
  DateTime? date;
  String? displayTime;
  num? memberCount;

  TimeOption(
      {this.from, this.to, this.displayTime, this.memberCount, this.date});

  TimeOption.fromModel(TimeOptionModel timeOptionModel) {
    from = timeOptionModel.from;
    to = timeOptionModel.to;
    displayTime = timeOptionModel.displayTime;
    memberCount = timeOptionModel.memberCount;
  }
}
