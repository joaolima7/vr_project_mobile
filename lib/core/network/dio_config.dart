import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class DioConfig {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    return dio;
  }
}
