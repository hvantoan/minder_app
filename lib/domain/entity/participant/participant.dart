import 'package:minder/data/model/match/participant_model.dart';

class Participant {
  String? userId;
  String? matchId;
  String? avatar;
  String? name;
  String? phone;
  String? email;

  Participant(this.userId, this.matchId, this.avatar, this.name, this.phone,
      this.email);

  Participant.fromModel(ParticipantModel participantModel) {
    userId = participantModel.userId;
    matchId = participantModel.matchId;
    avatar = participantModel.avatar;
    name = participantModel.name;
    phone = participantModel.phone;
    email = participantModel.email;
  }
}
