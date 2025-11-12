class AppConstants {
  AppConstants._();

  static const String appName = 'VR Notifications';
  static const String appVersion = '1.0.0';

  static const Duration pollingInterval = Duration(seconds: 3);
  static const Duration debounceTime = Duration(milliseconds: 500);

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 8.0;

  static const String emptyListMessage = 'Nenhuma notificação enviada ainda';
  static const String sendNotificationHint = 'Digite sua mensagem aqui...';
  static const String sendButtonText = 'Enviar Notificação';
}
