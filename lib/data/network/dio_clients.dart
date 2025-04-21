import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';

Dio buildBaseDio() {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  return dio;
}

Dio buildNaverDio() {
  final dio = buildBaseDio();
  dio.options.baseUrl = AppConstants.naverApiBaseUrl;
  dio.options.headers.addAll({
    'X-Naver-Client-Id': '',
    'X-Naver-Client-Secret': '',
  });
  return dio;
}

Dio buildVworldDio() {
  final dio = buildBaseDio();
  dio.options.baseUrl = AppConstants.vworldApiBaseUrl;
  return dio;
}
