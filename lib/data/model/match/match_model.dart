import 'package:minder/data/model/personal/stadium_model.dart';
import 'package:minder/data/model/personal/team_model.dart';

class MatchModel {
  String? id;
  String? hostTeamId;
  String? opposingTeamId;
  int? status;
  String? selectedDate;
  int? teamSide;
  MatchTeamModel? hostTeam;
  MatchTeamModel? opposingTeam;
  List<TimeChoiceModel>? timeChoices;

  MatchModel(
      this.id,
      this.hostTeamId,
      this.opposingTeamId,
      this.status,
      this.selectedDate,
      this.teamSide,
      this.hostTeam,
      this.opposingTeam,
      this.timeChoices);

  MatchModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    hostTeamId = json["hostTeamId"];
    opposingTeamId = json["opposingTeamId"];
    status = json["status"];
    selectedDate = json["selectedDate"];
    teamSide = json["teamSide"];
    hostTeam = json["hostTeam"] != null
        ? MatchTeamModel.fromJson(json["hostTeam"])
        : null;
    opposingTeam = json["opposingTeam"] != null
        ? MatchTeamModel.fromJson(json["opposingTeam"])
        : null;
    timeChoices = json["timeChooices"] != null
        ? (json["timeChooices"] as List)
            .map((e) => TimeChoiceModel.fromJson(e))
            .toList()
        : [];
  }
}

class MatchTeamModel {
  String? id;
  String? teamId;
  String? stadiumId;
  num? selectedDayOfWeek;
  num? from;
  num? to;
  DateTime? date;
  String? hostMatch;
  String? opposingMatch;
  StadiumModel? stadium;
  String? teamName;
  String? avatar;
  double? latitude;
  double? longitude;

  MatchTeamModel(
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
      this.avatar, this.latitude, this.longitude);

  MatchTeamModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    teamId = json["teamId"];
    stadiumId = json["stadiumId"];
    selectedDayOfWeek = json["selectedDayOfWeek"];
    from = json["from"];
    date = json["date"] != null ? DateTime.parse(json["date"]) : null;
    to = json["to"];
    stadium =
        json["stadium"] != null ? StadiumModel.fromJson(json["stadium"]) : null;
    teamName = json["teamName"];
    avatar = json["avatar"];
    latitude = json["latitude"]??0;
    longitude = json["longitude"]??0;
  }
}

class TimeChoiceModel {
  num? dayOfWeek;
  String? displayDay;
  DateTime? date;
  List<TimeOptionModel>? options;

  TimeChoiceModel(this.dayOfWeek, this.displayDay, this.date, this.options);

  TimeChoiceModel.fromJson(Map<String, dynamic> json) {
    dayOfWeek = json["dayOfWeek"];
    displayDay = json["displayDay"];
    date = json["date"] != null ? DateTime.parse(json["date"]) : null;
    options = json["opptions"] != null
        ? (json["opptions"] as List)
            .map((e) => TimeOptionModel.fromJson(e))
            .toList()
        : [];
  }
}

class TimeOptionModel {
  num? from;
  num? to;
  String? displayTime;
  num? memberCount;

  TimeOptionModel(this.from, this.to, this.displayTime, this.memberCount);

  TimeOptionModel.fromJson(Map<String, dynamic> json) {
    from = json["from"];
    to = json["to"];
    displayTime = json["displayTime"];
    memberCount = json["memberCount"];
  }
}
