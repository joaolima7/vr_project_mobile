import '../../../../../core/types/typedefs.dart';
import '../entities/notification.entity.dart';
import '../repositories/notification.repository.dart';

class GetNotificationStatusUseCase {
  final NotificationRepository _repository;

  const GetNotificationStatusUseCase({
    required NotificationRepository repository,
  }) : _repository = repository;

  ResultFuture<NotificationEntity> call({required String messageId}) async {
    return await _repository.getNotificationStatus(messageId: messageId);
  }
}
