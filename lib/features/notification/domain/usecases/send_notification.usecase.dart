import 'package:dartz/dartz.dart';

import '../../../../../core/types/typedefs.dart';
import '../../../../core/error/errors.dart';
import '../entities/notification.entity.dart';
import '../repositories/notification.repository.dart';

class SendNotificationUseCase {
  final NotificationRepository _repository;

  const SendNotificationUseCase({required NotificationRepository repository}) : _repository = repository;

  ResultFuture<NotificationEntity> call({required String content}) async {
    if (content.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Mensagem não pode ser vazia!'),
      );
    }

    return await _repository.sendNotification(content: content);
  }
}
