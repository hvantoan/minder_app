import 'package:minder/data/model/personal/user_model.dart';

class TeamModel {
  TeamModel(
      {required this.id,
      required this.code,
      required this.name,
      this.groupId,
      this.regency,
      this.createAt,
      this.description,
      this.avatar,
      this.cover,
      this.gameSettingModel,
      this.members});

  late String id;
  late String code;
  late String name;
  bool? isAutoLocation;
  bool? isAutoTime;
  String? groupId;
  int? regency;
  String? createAt;
  String? description;
  String? avatar;
  String? cover;
  GameSettingModel? gameSettingModel;
  List<MemberModel>? members;

  TeamModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    name = json["name"];
    regency = json["regency"];
    createAt = json["createAt"];
    isAutoTime = json["isAutoTime"];
    isAutoLocation = json["isAutoLocation"];
    avatar = json["avatar"];
    description = json["description"];
    cover = json["cover"];
    groupId = json["groupId"];
    if (json["gameSetting"] != null) {
      gameSettingModel = GameSettingModel.fromJson(json["gameSetting"]);
    }
    if (json["members"] != null) {
      members = (json["members"] as List)
          .map((e) => MemberModel.fromJson(e))
          .toList();
    }
  }
}

class MemberModel {
  late String id;
  late String userId;
  late String teamId;
  late int regency;
  UserModel? userModel;

  MemberModel(
      {required this.id,
      required this.userId,
      required this.teamId,
      required this.regency,
      this.userModel});

  MemberModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    teamId = json["teamId"];
    regency = json["regency"];
  }
}
