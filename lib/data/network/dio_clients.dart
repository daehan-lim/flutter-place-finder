import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_place_finder/app/constants/app_constants.dart';

import '../../core/exceptions/data_exceptions.dart';

/// Creates and configures a base Dio instance with common settings.
///
/// Sets up connection and receive timeouts, and adds logging interceptor
/// in debug mode.
/// Returns a configured [Dio] instance for HTTP requests.
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

/// Creates a Dio instance configured for Naver API requests.
///
/// Retrieves Naver API credentials from environment variables and
/// configures appropriate headers for authentication.
/// Throws [EnvFileException] if required credentials are missing.
///
/// Returns a [Dio] instance configured for Naver API.
Dio buildNaverDio() {
  final naverClientId = dotenv.env['NAVER_CLIENT_ID'];
  final naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET'];
  if (naverClientId == null) {
    throw EnvFileException('.env 파일에 NAVER_CLIENT_ID가 설정되지 않았습니다');
  } else if (naverClientSecret == null) {
    throw EnvFileException('.env 파일에 NAVER_CLIENT_SECRET가 설정되지 않았습니다');
  }

  final dio = buildBaseDio();
  dio.options.baseUrl = AppConstants.naverApiBaseUrl;
  dio.options.headers.addAll({
    'X-Naver-Client-Id': naverClientId,
    'X-Naver-Client-Secret': naverClientSecret,
  });
  return dio;
}

/// Creates a Dio instance configured for Vworld API requests.
///
/// Sets up the base URL for Vworld API endpoints.
/// Returns a [Dio] instance configured for Vworld API.
Dio buildVworldDio() {
  final dio = buildBaseDio();
  dio.options.baseUrl = AppConstants.vworldApiBaseUrl;
  return dio;
}
