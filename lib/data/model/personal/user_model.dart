class UserModel {
  UserModel({
    this.id,
    this.username,
    this.name,
    this.phone,
    this.sex,
    this.dayOfBirth,
    this.age,
    this.avatar,
    this.cover,
    this.description,
    this.gameSetting,
  });

  UserModel.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    phone = json['phone'];
    dayOfBirth = DateTime.parse(json['dayOfBirth']);
    sex = json['sex'];
    age = json['age'];
    avatar = json["avatar"];
    cover = json["cover"];
    description = json['description'];
    gameSetting = json['gameSetting'] != null
        ? GameSettingModel.fromJson(json['gameSetting'])
        : null;
    avatar = json["avatar"];
    cover = json["cover"];
  }

  String? id;
  String? username;
  String? name;
  String? phone;
  DateTime? dayOfBirth;
  num? sex;
  num? age;
  String? avatar;
  String? cover;
  String? description;
  GameSettingModel? gameSetting;
}

class GameSettingModel {
  GameSettingModel({
    this.id,
    this.gameTypes,
    this.gameTime,
    this.longitude,
    this.latitude,
    this.radius,
    this.rank,
    this.positions,
    this.point,
  });

  GameSettingModel.fromJson(dynamic json) {
    id = json['id'];
    gameTypes = json['gameTypes'] != null ? json['gameTypes'].cast<num>() : [];
    gameTime = json['gameTime'] != null
        ? GameTimeModel.fromJson(json['gameTime'])
        : null;
    positions = json["positions"] != null ? json['positions'].cast<num>() : [];
    longitude = json['longitude'];
    latitude = json['latitude'];
    radius = json['radius'];
    rank = json['rank'];
    point = json['point'];
    positions = json['positions'] != null ? json['positions'].cast<num>() : [];
  }

  Map<String, dynamic> toJson() {
    return {"gameTypes": gameTypes, "rank": rank};
  }

  String? id;
  List<num>? gameTypes;
  List<num>? positions;
  GameTimeModel? gameTime;
  num? longitude;
  num? latitude;
  num? radius;
  num? rank;
  num? point;
}

class GameTimeModel {
  GameTimeModel({
    this.id,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  GameTimeModel.fromJson(dynamic json) {
    id = json["id"];
    monday = json['monday'] != null ? json['monday'].cast<num>() : [];
    tuesday = json['tuesday'] != null ? json['tuesday'].cast<num>() : [];
    wednesday = json['wednesday'] != null ? json['wednesday'].cast<num>() : [];
    thursday = json['thursday'] != null ? json['thursday'].cast<num>() : [];
    friday = json['friday'] != null ? json['friday'].cast<num>() : [];
    saturday = json['saturday'] != null ? json['saturday'].cast<num>() : [];
    sunday = json['sunday'] != null ? json['sunday'].cast<num>() : [];
  }

  String? id;
  List<num>? monday;
  List<num>? tuesday;
  List<num>? wednesday;
  List<num>? thursday;
  List<num>? friday;
  List<num>? saturday;
  List<num>? sunday;
}
