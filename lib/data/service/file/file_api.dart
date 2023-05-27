import 'dart:io';

import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/util/constant/enum/image_enum.dart';
import 'package:minder/util/constant/path/service_path.dart';

class FileAPI {
  Future<void> create(
      {required String id, required File file, required ImageEnum type}) async {
    try {
      Map<String, dynamic> params = {
        "itemId": id,
        "fileName": file.path
            .substring(file.path.lastIndexOf("/") + 1, file.path.length),
        "itemType": type.index,
        "data": file.readAsBytesSync()
      };
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.file, withToken: true, params: params);
      if (response.isSuccess) {
        return;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }
}
