// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';


class ApiLogger {
  static void printLog(Object object) async {
   log('$object');
  }

  //Cyan:
  static void specialLog(Object msg) {
    log('\x1B[36m$msg\x1B[0m');
  }

  // Blue text
  static void logInfo(Object msg) {
    log('\x1B[34m$msg\x1B[0m');
  }

// Green text
  static void logSuccess(Object msg) {
    log('\x1B[32m$msg\x1B[0m');
  }

// Yellow text
  static void logWarning(Object msg) {
    log('\x1B[33m$msg\x1B[0m');
  }

// Red text
  static void logError(Object msg) {
    log('\x1B[31m$msg\x1B[0m');
  }

  static void logDioError(DioException error) {
    if (error.response != null) {
      logError('+++++++++++++++Response++++++++++++++++++++');
      logError('Response Code - ${error.response!.statusCode}');
      logError('Response - ${error.response!.data}');
      logError('////////////////////////////////////////////////////////////');
    } else {
      logError('+++++++++++++++Response NULL++++++++++++++++++++');
    }

    logError('+++++++++++++++Stack Trace++++++++++++++++++++');
    logError('StackTrace - $error');
    logError('///////////////////////////////////////////////////////////////');
  }

  static void logDioRequest(RequestOptions request) {
    logInfo('+++++++++++++++Request++++++++++++++++++++');
    logInfo('Url - ${request.baseUrl + request.path}');
    logInfo('Type - ${request.method}');
    logInfo('Headers - ${jsonEncode(request.headers)}');
    logInfo('Request - ${jsonEncode(request.data)}');
    logInfo('QueryParameters - ${request.queryParameters}');
  }

  static void logDioResponse(Response response) {
    logSuccess('//////////////////////////////////////////////////////////');
    logSuccess('+++++++++++++++Response++++++++++++++++++++');
    logSuccess('Response From URL - ${response.requestOptions.baseUrl + response.requestOptions.path}');
    logSuccess('Response Code - ${response.statusCode}');
    logSuccess('Response - ${jsonEncode(response.data)}');
    logSuccess('/////////////////////////////////////////////////////////');
  }
}