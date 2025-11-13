import 'package:flutter_test/flutter_test.dart';
import 'package:vr_project_mobile/features/notification/domain/entities/notification.entity.dart';

void main() {
  group('NotificationEntity', () {
    test('should create entity with correct properties', () {
      final now = DateTime.now();
      const messageId = 'test-id';
      const content = 'Test message';
      const status = NotificationStatus.queued;

      final entity = NotificationEntity(
        messageId: messageId,
        messageContent: content,
        status: status,
        createdAt: now,
      );

      expect(entity.messageId, messageId);
      expect(entity.messageContent, content);
      expect(entity.status, status);
      expect(entity.createdAt, now);
    });

    test('should support value equality', () {
      final now = DateTime.now();
      final entity1 = NotificationEntity(
        messageId: 'id',
        messageContent: 'content',
        status: NotificationStatus.queued,
        createdAt: now,
      );
      final entity2 = NotificationEntity(
        messageId: 'id',
        messageContent: 'content',
        status: NotificationStatus.queued,
        createdAt: now,
      );

      expect(entity1, equals(entity2));
    });

    test('copyWith should create new instance with updated values', () {
      final original = NotificationEntity(
        messageId: 'id',
        messageContent: 'content',
        status: NotificationStatus.queued,
        createdAt: DateTime.now(),
      );

      final updated = original.copyWith(status: NotificationStatus.success);

      expect(updated.status, NotificationStatus.success);
      expect(updated.messageId, original.messageId);
      expect(updated.messageContent, original.messageContent);
    });

    group('NotificationStatus', () {
      test('should parse status from string correctly', () {
        expect(
          NotificationStatus.fromString('ENFILEIRADO'),
          NotificationStatus.queued,
        );
        expect(
          NotificationStatus.fromString('AGUARDANDO_PROCESSAMENTO'),
          NotificationStatus.pending,
        );
        expect(
          NotificationStatus.fromString('PROCESSADO_SUCESSO'),
          NotificationStatus.success,
        );
        expect(
          NotificationStatus.fromString('FALHA_PROCESSAMENTO'),
          NotificationStatus.failure,
        );
      });

      test('should default to pending for unknown status', () {
        expect(
          NotificationStatus.fromString('UNKNOWN'),
          NotificationStatus.pending,
        );
      });
    });
  });
}
