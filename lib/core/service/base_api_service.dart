import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/util/constant/constant/service_constant.dart';
import 'package:minder/util/helper/token_helper.dart';

class BaseAPIService {
  static Future<Map<String, String>> getHeaders({bool withToken = true}) async {
    String? token;
    if (withToken == true) {
      bool isValidToken = await TokenHelper.checkToken();
      if (isValidToken) token = await TokenHelper.getAccessToken();
    }
    return {
      HttpHeaders.acceptHeader: "application/json",
      if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json"
    };
  }

  static Future<BaseResponse> post(
      {required String uri,
      required Map<String, dynamic> params,
      bool withToken = true}) async {
    try {
      final client = http.Client();
      Future.delayed(ServiceConstant.apiWaitingDuration)
          .whenComplete(() => client.close());
      Map<String, String> headers = await getHeaders(withToken: withToken);
      http.Response response = await client.post(Uri.parse(uri),
          headers: headers, body: jsonEncode(params));
      await Future.delayed(DebugData.fakeLoadingDuration);
      return BaseResponse.fromHttpResponse(response);
    } catch (e) {
      if (e is ResponseException) {
        rethrow;
      } else {
        debugPrint("API service post failed: $e");
        throw ServerException();
      }
    }
  }

  static Future<BaseResponse> get(
      {required String uri, bool withToken = true}) async {
    try {
      final client = http.Client();
      Future.delayed(ServiceConstant.apiWaitingDuration)
          .whenComplete(() => client.close());
      Map<String, String> headers = await getHeaders(withToken: withToken);
      http.Response response =
          await client.get(Uri.parse(uri), headers: headers);
      await Future.delayed(DebugData.fakeLoadingDuration);
      return BaseResponse.fromHttpResponse(response);
    } catch (e) {
      if (e is ResponseException) {
        rethrow;
      } else {
        debugPrint("API service get failed: $e");
        throw ServerException();
      }
    }
  }

  static Future<BaseResponse> delete(
      {required String uri, bool withToken = true}) async {
    try {
      final client = http.Client();
      Future.delayed(ServiceConstant.apiWaitingDuration)
          .whenComplete(() => client.close());
      Map<String, String> headers = await getHeaders(withToken: withToken);
      http.Response response =
          await client.delete(Uri.parse(uri), headers: headers);
      await Future.delayed(DebugData.fakeLoadingDuration);
      return BaseResponse.fromHttpResponse(response);
    } catch (e) {
      if (e is ResponseException) {
        rethrow;
      } else {
        debugPrint("API service delete failed: $e");
        throw ServerException();
      }
    }
  }
}
