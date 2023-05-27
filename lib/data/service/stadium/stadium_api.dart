import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/personal/stadium_model.dart';
import 'package:minder/util/constant/path/service_path.dart';

class StadiumAPI {
  Future<List<StadiumModel>> getStadiums() async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: "${ServicePath.stadium}/${ServicePath.stadiumList}",
          withToken: true,
          params: {});
      if (response.isSuccess) {
        final List<StadiumModel> stadiumModels =
            (response.data!["items"] as List).map((stadium) {
          return StadiumModel.fromJson(stadium);
        }).toList();
        return stadiumModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }
}
