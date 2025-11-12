abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}
