import 'package:minder/data/model/personal/team_model.dart';
import 'package:minder/domain/entity/user/user.dart';

class Team {
  Team({
    required this.id,
    required this.code,
    required this.name,
    this.groupId,
    this.regency,
    this.createAt,
    this.description,
    this.avatar,
    this.cover,
    this.gameSetting,
    this.members,
  });

  late String id;
  late String code;
  late String name;
  String? groupId;
  bool? isAutoLocation;
  bool? isAutoTime;
  int? regency;
  String? createAt;
  String? description;
  String? avatar;
  String? cover;
  GameSetting? gameSetting;
  List<Member>? members;

  Team.fromModel(TeamModel teamModel) {
    id = teamModel.id;
    code = teamModel.code;
    name = teamModel.name;
    isAutoTime = teamModel.isAutoTime;
    isAutoLocation = teamModel.isAutoLocation;
    regency = teamModel.regency;
    createAt = teamModel.createAt;
    description = teamModel.description;
    avatar = teamModel.avatar;
    cover = teamModel.cover;
    groupId = teamModel.groupId;

    if (teamModel.gameSettingModel != null) {
      gameSetting = GameSetting.fromModel(teamModel.gameSettingModel!);
    }
    if (teamModel.members != null) {
      members = teamModel.members!.map((e) => Member.fromModel(e)).toList();
    }
  }
}

class Member {
  late String id;
  late String userId;
  late String teamId;
  late int regency;
  User? user;

  Member(
      {required this.id,
      required this.userId,
      required this.teamId,
      required this.regency,
      this.user});

  Member.fromModel(MemberModel memberModel) {
    id = memberModel.id;
    userId = memberModel.userId;
    teamId = memberModel.teamId;
    regency = memberModel.regency;
    if (memberModel.userModel != null) {
      user = User.fromModel(memberModel.userModel!);
    }
  }
}
