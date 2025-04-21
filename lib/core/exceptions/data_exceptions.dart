class ApiException implements Exception {
  final int? statusCode;
  final dynamic data;

  ApiException({this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: statusCode=$statusCode; data=$data';
  }
}


class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

class EnvFileException implements Exception {
  final String message;

  EnvFileException(this.message);

  @override
  String toString() {
    return 'EnvFileException: $message';
  }
}
