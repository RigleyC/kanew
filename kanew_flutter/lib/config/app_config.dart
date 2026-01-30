import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String? apiUrl;
  final String webUrl;

  AppConfig({
    required this.apiUrl,
    required this.webUrl,
  });

  static Future<AppConfig> loadConfig() async {
    final config = await _loadJsonConfig();

    // API URL priority: Env > Config > Default
    const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
    final String? apiUrl = serverUrlFromEnv.isNotEmpty
        ? serverUrlFromEnv
        : config['apiUrl'];

    // Web URL priority: Env > Config > Default
    const webUrlFromEnv = String.fromEnvironment('WEB_URL');
    final String webUrl = webUrlFromEnv.isNotEmpty
        ? webUrlFromEnv
        : config['webUrl'] ?? 'http://localhost:8080';

    return AppConfig(
      apiUrl: apiUrl,
      webUrl: webUrl,
    );
  }

  static Future<Map<String, dynamic>> _loadJsonConfig() async {
    try {
      final data = await rootBundle.loadString(
        'assets/config.json',
      );
      return jsonDecode(data);
    } catch (_) {
      return {};
    }
  }
}
