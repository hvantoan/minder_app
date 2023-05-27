import 'package:minder/data/model/personal/team_model.dart';
import 'package:minder/data/model/personal/user_model.dart';

class InviteModel {
  late String id;
  late String userId;
  late String teamId;
  TeamModel? teamModel;
  UserModel? userModel;
  late String description;
  late int type;
  late String createAt;

  InviteModel(
      {required this.id,
      required this.userId,
      required this.teamId,
      this.teamModel,
      required this.description,
      required this.type,
      required this.createAt});

  InviteModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    createAt = json["createAt"];
    userId = json["userId"];
    description = json["description"];
    type = json["type"];
    teamId = json["teamId"];
  }
}
