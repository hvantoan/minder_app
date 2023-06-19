class ParticipantModel {
  String? userId;
  String? matchId;
  String? avatar;
  String? name;
  String? phone;
  String? email;

  ParticipantModel(this.userId, this.matchId, this.avatar, this.name,
      this.phone, this.email);

  ParticipantModel.fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    matchId = json["matchId"];
    avatar = json["avatar"];
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
  }
}
