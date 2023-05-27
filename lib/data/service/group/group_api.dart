import 'package:minder/core/exception/authentication_exception.dart';
import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/group/group_model.dart';
import 'package:minder/util/constant/path/service_path.dart';

class GroupAPI {
  Future<List<GroupModel>> list(
      {required int pageIndex, required int pageSize}) async {
    try {
      Map<String, dynamic> params = {
        "pageIndex": pageIndex,
        "pageSize": pageSize
      };
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.listGroup, withToken: true, params: params);
      if (response.isSuccess) {
        List<GroupModel> groups = (response.data?['items'] as List)
            .map((o) => GroupModel.fromMap(o))
            .toList();
        return groups;
      }
      switch (response.statusCode) {
        default:
          throw DataParsingException();
      }
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }
}
