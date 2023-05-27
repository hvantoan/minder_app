class StadiumModel {
  String? id;
  String? userId;
  String? code;
  String? name;
  String? avatar;
  String? phone;
  double? longitude;
  double? latitude;
  String? address;
  String? createdAt;
  AreaModel? province;
  AreaModel? district;
  AreaModel? commune;
  String? fullAddress;

  StadiumModel(
      {this.id,
      this.userId,
      this.code,
      this.name,
      this.avatar,
      this.phone,
      this.longitude,
      this.latitude,
      this.address,
      this.createdAt,
      this.province,
      this.district,
      this.commune,
      this.fullAddress});

  StadiumModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    code = json["code"];
    name = json["name"];
    avatar = json["avatar"];
    phone = json["phone"];
    longitude = json["longitude"];
    latitude = json["latitude"];
    address = json["address"];
    createdAt = json["createdAt"];
    fullAddress = json["fullAddress"];
    province =
        json["province"] != null ? AreaModel.fromJson(json["province"]) : null;
    district =
        json["district"] != null ? AreaModel.fromJson(json["district"]) : null;
    commune =
        json["commune"] != null ? AreaModel.fromJson(json["commune"]) : null;
  }
}

class AreaModel {
  String? code;
  String? name;

  AreaModel({this.code, this.name});

  AreaModel.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    name = json["name"];
  }
}
