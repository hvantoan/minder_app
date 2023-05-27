import 'package:minder/domain/entity/user/user.dart' as user;

class UserDto {
  String? id;
  String? username;
  String? name;
  String? phone;
  int? sex;
  DateTime? dayOfBirth;
  String? description;
  GameSetting? gameSetting;
  String? avatar;
  String? cover;

  UserDto({
    this.id,
    this.username,
    this.name,
    this.phone,
    this.sex,
    this.dayOfBirth,
    this.description,
    this.gameSetting,
    this.avatar,
    this.cover,
  });

  UserDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    phone = json['phone'];
    sex = json['sex'];
    dayOfBirth = DateTime.parse(json['dayOfBirth']);
    description = json['description'];
    gameSetting = json['gameSetting'] != null
        ? GameSetting.fromJson(json['gameSetting'])
        : null;
    avatar = json['avatar'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['phone'] = phone;
    data['sex'] = sex;
    data['dayOfBirth'] = dayOfBirth != null
        ? dayOfBirth!.toUtc().toString()
        : DateTime.now().toString();
    data['description'] = description;
    if (gameSetting != null) {
      data['gameSetting'] = gameSetting!.toJson();
    }
    data['avatar'] = avatar;
    data['cover'] = cover;
    return data;
  }

  String toDisplaySex() {
    switch (sex) {
      case 0:
        return "Nam";
      case 1:
        return "Nữ";
      case 2:
        return "Khác";
      default:
        return "Không sác định";
    }
  }

  sexToValue(String text) {
    switch (text) {
      case "Nam":
        sex = 0;
        break;
      case "Nữ":
        sex = 1;
        break;
      case "Khác":
        sex = 2;
        break;
      default:
        sex = -1;
    }
  }

  String calculateAge() {
    DateTime birthDate = dayOfBirth ?? DateTime.now();
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }
}

class GameSetting {
  String? id;
  List<int>? gameTypes;
  GameTime? gameTime;
  List<int>? positions;
  double? longitude;
  double? latitude;
  double? radius;
  int? rank;

  GameSetting({
    this.id,
    this.gameTypes,
    this.gameTime,
    this.positions,
    this.longitude,
    this.latitude,
    this.radius,
    this.rank,
  });

  GameSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    gameTypes = List<dynamic>.from(json['gameTypes'] ?? [])
        .map((i) => i as int)
        .toList();
    gameTime =
        json['gameTime'] != null ? GameTime.fromJson(json['gameTime']) : null;
    positions = List<dynamic>.from(json['positions'] ?? [])
        .map((i) => i as int)
        .toList();
    longitude = json['longitude'];
    latitude = json['latitude'];
    radius = json['radius'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['gameTypes'] = gameTypes;
    if (gameTime != null) {
      data['gameTime'] = gameTime!.toJson();
    }
    data['positions'] = positions;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['radius'] = radius;
    data['rank'] = rank;
    return data;
  }
}

class GameTime {
  List<int>? monday;
  List<int>? tuesday;
  List<int>? wednesday;
  List<int>? thursday;
  List<int>? friday;
  List<int>? saturday;
  List<int>? sunday;

  GameTime(
      {this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  GameTime.fromJson(Map<String, dynamic> json) {
    monday = json['monday'].cast<int>();
    tuesday = json['tuesday'].cast<int>();
    wednesday = json['wednesday'].cast<int>();
    thursday = json['thursday'].cast<int>();
    friday = json['friday'].cast<int>();
    saturday = json['saturday'].cast<int>();
    sunday = json['sunday'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['monday'] = monday;
    data['tuesday'] = tuesday;
    data['wednesday'] = wednesday;
    data['thursday'] = thursday;
    data['friday'] = friday;
    data['saturday'] = saturday;
    data['sunday'] = sunday;
    return data;
  }

  user.GameTime? toGameTime() {
    return user.GameTime(
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday);
  }
}
