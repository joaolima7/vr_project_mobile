abstract class NetworkClient {
  Future<Map<String, dynamic>> post({required String endpoint, required Map<String, dynamic> body});

  Future<Map<String, dynamic>> get({required String endpoint});
}
