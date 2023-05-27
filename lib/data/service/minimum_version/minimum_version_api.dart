import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/util/constant/path/service_path.dart';

class MinimumVersionAPI {
  Future<String> getRawMinimumVersion() async {
    try {
      final BaseResponse baseResponse = await BaseAPIService.get(
          uri: ServicePath.appVersion, withToken: false);
      if (baseResponse.isSuccess) {
        return baseResponse.data!["ver"];
      }
      throw DataParsingException();
    } catch (e) {
      if (e is ResponseException) rethrow;
      throw DataParsingException();
    }
  }
}
