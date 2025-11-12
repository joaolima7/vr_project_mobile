import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import 'network_client.dart';

class NetworkClientImpl implements NetworkClient {
  final Dio _dio;

  NetworkClientImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: body);

      if (response.statusCode == 202 || response.statusCode == 200) {
        return response.data;
      }

      throw ServerException(
        message: 'Erro ao enviar notificação',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> get({
    required String endpoint,
  }) async {
    try {
      final response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        return response.data;
      }

      throw ServerException(
        message: 'Erro ao buscar status',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Timeout: Verifique sua conexão',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        return ServerException(
          message: error.response?.data['message'] ?? 'Erro no servidor',
          statusCode: error.response?.statusCode ?? 500,
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Erro de conexão. Verifique se o backend está rodando',
        );

      default:
        return NetworkException(
          message: 'Erro de rede: ${error.message}',
        );
    }
  }
}
