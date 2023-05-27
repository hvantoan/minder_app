import 'package:minder/data/model/personal/user_model.dart';
import 'package:minder/util/constant/enum/gender_enum.dart';
import 'package:minder/util/constant/enum/position_enum.dart';

class User {
  User({
    this.id,
    this.username,
    this.name,
    this.phone,
    this.dayOfBirth,
    this.sex,
    this.age,
    this.avatar,
    this.cover,
    this.description,
    this.gameSetting,
  });

  User.fromModel(UserModel userModel) {
    id = userModel.id;
    username = userModel.username;
    name = userModel.name;
    phone = userModel.phone;
    dayOfBirth = userModel.dayOfBirth;
    sex = Gender.values.elementAt(userModel.sex?.toInt() ?? 2);
    age = userModel.age;
    avatar = userModel.avatar;
    cover = userModel.cover;
    description = userModel.description;
    if (userModel.gameSetting != null) {
      gameSetting = GameSetting.fromModel(userModel.gameSetting!);
    }
  }

  String? id;
  String? username;
  String? name;
  String? phone;
  DateTime? dayOfBirth;
  Gender? sex;
  num? age;
  String? avatar;
  String? cover;
  String? description;
  GameSetting? gameSetting;
}

class GameSetting {
  GameSetting({
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

  GameSetting.fromModel(GameSettingModel gameSettingModel) {
    id = gameSettingModel.id;
    gameTypes = gameSettingModel.gameTypes;
    if (gameSettingModel.gameTime != null) {
      gameTime = GameTime.fromModel(gameSettingModel.gameTime!);
    }
    latitude = gameSettingModel.latitude;
    longitude = gameSettingModel.longitude;
    rank = gameSettingModel.rank;
    radius = gameSettingModel.radius;
    positions = gameSettingModel.positions != null
        ? gameSettingModel.positions!
            .map((e) => Position.values.elementAt(e.toInt()))
            .toList()
        : null;
    point = gameSettingModel.point;
  }

  String? id;
  List<num>? gameTypes;
  GameTime? gameTime;
  num? longitude;
  num? latitude;
  num? radius;
  num? rank;
  List<Position>? positions;
  num? point;
}

class GameTime {
  GameTime({
    this.id,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  GameTime.fromModel(GameTimeModel gameTimeModel) {
    id = gameTimeModel.id;
    monday = gameTimeModel.monday;
    tuesday = gameTimeModel.tuesday;
    wednesday = gameTimeModel.wednesday;
    thursday = gameTimeModel.thursday;
    friday = gameTimeModel.friday;
    saturday = gameTimeModel.saturday;
    sunday = gameTimeModel.sunday;
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
