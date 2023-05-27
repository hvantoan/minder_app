import 'package:minder/data/model/personal/stadium_model.dart';
import 'package:minder/domain/entity/stadium/area.dart';

class Stadium {
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
  Area? province;
  Area? district;
  Area? commune;
  String? fullAddress;

  Stadium(
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

  Stadium.fromModel(StadiumModel stadiumModel) {
    id = stadiumModel.id;
    userId = stadiumModel.userId;
    code = stadiumModel.code;
    avatar = stadiumModel.avatar;
    name = stadiumModel.name;
    phone = stadiumModel.phone;
    longitude = stadiumModel.longitude;
    latitude = stadiumModel.latitude;
    address = stadiumModel.address;
    createdAt = stadiumModel.createdAt;
    fullAddress = stadiumModel.fullAddress;
    province = stadiumModel.province != null
        ? Area.fromModel(stadiumModel.province!)
        : null;
    district = stadiumModel.district != null
        ? Area.fromModel(stadiumModel.district!)
        : null;
    commune = stadiumModel.commune != null
        ? Area.fromModel(stadiumModel.commune!)
        : null;
  }
}
