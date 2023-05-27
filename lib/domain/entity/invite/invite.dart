import 'package:minder/data/model/personal/invite_model.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';

class Invite {
  late String id;
  late String userId;
  late String teamId;
  Team? team;
  User? user;
  late String description;
  late int type;
  late String createAt;

  Invite(
      {required this.id,
      required this.userId,
      required this.teamId,
      required this.description,
      required this.type,
      required this.createAt});

  Invite.fromModel(InviteModel inviteModel) {
    id = inviteModel.id;
    createAt = inviteModel.createAt;
    userId = inviteModel.userId;
    description = inviteModel.description;
    type = inviteModel.type;
    teamId = inviteModel.teamId;
    if (inviteModel.teamModel != null) {
      team = Team.fromModel(inviteModel.teamModel!);
    }
    if (inviteModel.userModel != null) {
      user = User.fromModel(inviteModel.userModel!);
    }
  }
}
