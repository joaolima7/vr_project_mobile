import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/errors.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/types/typedefs.dart';
import '../../domain/entities/notification.entity.dart';
import '../../domain/repositories/notification.repository.dart';
import '../datasources/remote/notification_remote.datasource.dart';
import '../mappers/notification.mapper.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  const NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required Uuid uuid,
  }) : _remoteDataSource = remoteDataSource;

  @override
  ResultFuture<NotificationEntity> sendNotification({
    required String content,
  }) async {
    try {
      final dto = await _remoteDataSource.sendNotification(content: content);

      final entity = NotificationEntity(
        messageId: dto.mensagemId,
        messageContent: content,
        status: NotificationStatus.fromString(dto.status),
        createdAt: DateTime.now(),
      );

      return Right(entity);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<NotificationEntity> getNotificationStatus({
    required String messageId,
  }) async {
    try {
      final dto = await _remoteDataSource.getStatus(messageId: messageId);

      final entity = dto.toEntity();

      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
