import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification.entity.dart';
import '../../domain/usecases/get_notification_status.usecase.dart';
import '../../domain/usecases/send_notification.usecase.dart';
import 'notification.event.dart';
import 'notification.state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SendNotificationUseCase _sendNotificationUseCase;
  final GetNotificationStatusUseCase _getNotificationStatusUseCase;

  Timer? _pollingTimer;
  final Map<String, Timer> _activePolls = {};

  NotificationBloc({
    required SendNotificationUseCase sendNotificationUseCase,
    required GetNotificationStatusUseCase getNotificationStatusUseCase,
  }) : _sendNotificationUseCase = sendNotificationUseCase,
       _getNotificationStatusUseCase = getNotificationStatusUseCase,
       super(const NotificationState()) {
    on<SendNotificationEvent>(_onSendNotification);
    on<UpdateNotificationStatusEvent>(_onUpdateNotificationStatus);
    on<StartPollingEvent>(_onStartPolling);
    on<StopPollingEvent>(_onStopPolling);
    on<ClearErrorEvent>(_onClearError);
  }

  Future<void> _onSendNotification(
    SendNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStateStatus.loading));

    final result = await _sendNotificationUseCase(content: event.content);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStateStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (notification) {
        final updatedNotifications = [
          notification,
          ...state.notifications,
        ];

        emit(
          state.copyWith(
            status: NotificationStateStatus.success,
            notifications: updatedNotifications,
          ),
        );

        add(StartPollingEvent(messageId: notification.messageId));
      },
    );
  }

  Future<void> _onUpdateNotificationStatus(
    UpdateNotificationStatusEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _getNotificationStatusUseCase(
      messageId: event.messageId,
    );

    result.fold(
      (failure) {},
      (updatedNotification) {
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.messageId == updatedNotification.messageId) {
            return notification.copyWith(status: updatedNotification.status);
          }
          return notification;
        }).toList();

        emit(
          state.copyWith(
            notifications: updatedNotifications,
            status: NotificationStateStatus.success,
          ),
        );

        if (updatedNotification.status == NotificationStatus.success || updatedNotification.status == NotificationStatus.failure) {
          _stopPollingForMessage(event.messageId);
        }
      },
    );
  }

  void _onStartPolling(
    StartPollingEvent event,
    Emitter<NotificationState> emit,
  ) {
    _activePolls[event.messageId]?.cancel();

    _activePolls[event.messageId] = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        add(UpdateNotificationStatusEvent(messageId: event.messageId));
      },
    );

    emit(state.copyWith(isPolling: true));
  }

  void _onStopPolling(
    StopPollingEvent event,
    Emitter<NotificationState> emit,
  ) {
    for (var timer in _activePolls.values) {
      timer.cancel();
    }
    _activePolls.clear();
    _pollingTimer?.cancel();

    emit(state.copyWith(isPolling: false));
  }

  void _stopPollingForMessage(String messageId) {
    _activePolls[messageId]?.cancel();
    _activePolls.remove(messageId);
  }

  void _onClearError(
    ClearErrorEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        status: NotificationStateStatus.initial,
        errorMessage: null,
      ),
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    for (var timer in _activePolls.values) {
      timer.cancel();
    }
    return super.close();
  }
}
