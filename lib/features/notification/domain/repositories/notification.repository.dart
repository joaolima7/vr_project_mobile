import '../../../../../core/types/typedefs.dart';
import '../entities/notification.entity.dart';

abstract class NotificationRepository {
  ResultFuture<NotificationEntity> sendNotification({
    required String content,
  });

  ResultFuture<NotificationEntity> getNotificationStatus({
    required String messageId,
  });
}
