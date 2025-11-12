import 'package:equatable/equatable.dart';

enum NotificationStatus {
  queued('ENFILEIRADO'),
  pending('AGUARDANDO_PROCESSAMENTO'),
  success('PROCESSADO_SUCESSO'),
  failure('FALHA_PROCESSAMENTO');

  final String value;
  const NotificationStatus(this.value);

  static NotificationStatus fromString(String value) {
    return NotificationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationStatus.pending,
    );
  }
}

class NotificationEntity extends Equatable {
  final String messageId;
  final String messageContent;
  final NotificationStatus status;
  final DateTime createdAt;

  const NotificationEntity({
    required this.messageId,
    required this.messageContent,
    required this.status,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    String? messageId,
    String? messageContent,
    NotificationStatus? status,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      messageId: messageId ?? this.messageId,
      messageContent: messageContent ?? this.messageContent,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [messageId, messageContent, status, createdAt];
}
