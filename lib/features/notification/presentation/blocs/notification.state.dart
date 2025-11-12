import 'package:equatable/equatable.dart';

import '../../domain/entities/notification.entity.dart';

enum NotificationStateStatus {
  initial,
  loading,
  success,
  error,
  polling,
}

class NotificationState extends Equatable {
  final NotificationStateStatus status;
  final List<NotificationEntity> notifications;
  final String? errorMessage;
  final bool isPolling;

  const NotificationState({
    this.status = NotificationStateStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.isPolling = false,
  });

  NotificationState copyWith({
    NotificationStateStatus? status,
    List<NotificationEntity>? notifications,
    String? errorMessage,
    bool? isPolling,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
      isPolling: isPolling ?? this.isPolling,
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage, isPolling];
}
