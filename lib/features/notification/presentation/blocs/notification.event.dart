import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class SendNotificationEvent extends NotificationEvent {
  final String content;

  const SendNotificationEvent({required this.content});

  @override
  List<Object?> get props => [content];
}

class UpdateNotificationStatusEvent extends NotificationEvent {
  final String messageId;

  const UpdateNotificationStatusEvent({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class StartPollingEvent extends NotificationEvent {
  final String messageId;

  const StartPollingEvent({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class StopPollingEvent extends NotificationEvent {
  const StopPollingEvent();
}

class ClearErrorEvent extends NotificationEvent {
  const ClearErrorEvent();
}
