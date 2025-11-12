class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.73:8080';

  static const String sendNotification = '/api/notificar';
  static String getStatus(String messageId) => '/api/notificacao/status/$messageId';
}
