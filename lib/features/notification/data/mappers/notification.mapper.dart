import '../../domain/entities/notification.entity.dart';
import '../dtos/notification_response.dto.dart';

extension NotificationMapper on NotificationDataDto {
  NotificationEntity toEntity() {
    return NotificationEntity(
      messageId: mensagemId,
      messageContent: '',
      status: NotificationStatus.fromString(status),
      createdAt: DateTime.now(),
    );
  }
}
