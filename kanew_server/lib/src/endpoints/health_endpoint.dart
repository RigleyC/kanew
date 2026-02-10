import 'package:serverpod/serverpod.dart';

class HealthEndpoint extends Endpoint {
  Future<Map<String, dynamic>> check(Session session) async {
    return {
      'status': 'healthy',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
