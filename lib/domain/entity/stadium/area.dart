import 'package:minder/data/model/personal/stadium_model.dart';

class Area {
  String? code;
  String? name;

  Area({this.code, this.name});

  Area.fromModel(AreaModel areaModel) {
    code = areaModel.code;
    name = areaModel.name;
  }
}
