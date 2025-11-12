import '../../../../../core/network/network_client.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/error/exceptions.dart';
import '../../dtos/notification_request.dto.dart';
import '../../dtos/notification_response.dto.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationDataDto> sendNotification({required String content});
  Future<NotificationDataDto> getStatus({required String messageId});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NetworkClient _client;

  const NotificationRemoteDataSourceImpl({required NetworkClient client}) : _client = client;

  @override
  Future<NotificationDataDto> sendNotification({
    required String content,
  }) async {
    try {
      final request = NotificationRequestDto(conteudoMensagem: content);

      final response = await _client.post(
        endpoint: ApiEndpoints.sendNotification,
        body: request.toJson(),
      );

      final dto = NotificationResponseDto.fromJson(response);
      return dto.data;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<NotificationDataDto> getStatus({required String messageId}) async {
    try {
      final response = await _client.get(
        endpoint: ApiEndpoints.getStatus(messageId),
      );

      final dto = NotificationResponseDto.fromJson(response);
      return dto.data;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
