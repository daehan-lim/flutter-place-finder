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
  final Error? cause;

  NetworkException(this.message, [this.cause]);

  @override
  String toString() {
    return 'NetworkException: $message\n$cause';
  }
}
