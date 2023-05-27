import 'dart:convert';

import 'package:http/http.dart';
import 'package:minder/core/exception/exception.dart';
import 'package:minder/util/constant/enum/response_status_case_enum.dart';
import 'package:minder/util/helper/response_helper.dart';

class BaseResponse {
  BaseResponse(
      {required this.isSuccess,
      required this.statusCode,
      required this.message,
      this.data});

  final bool isSuccess;
  final int statusCode;
  final String message;
  final Map<String, dynamic>? data;

  static BaseResponse fromHttpResponse(Response response) {
    try {
      ResponseStatusCase responseStatusCase =
          ResponseHelper.checkResponseStatusCase(response.statusCode);
      if (responseStatusCase == ResponseStatusCase.unAuthorization) {
        throw AuthorizationException();
      }
      if (responseStatusCase == ResponseStatusCase.serverDisconnect) {
        throw ServerException();
      }
      Map<String, dynamic> result =
          json.decode(utf8.decode(response.bodyBytes));
      return BaseResponse(
        isSuccess: result["response"]["success"],
        statusCode: result["response"]["statusCode"],
        message: result["response"]["message"],
        data: result["data"],
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw ResponseDataParsingException();
    }
  }
}
