// lib/services/n8n_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/env.dart';

class N8nService {
  Future<bool> registerUser(String name, String email) async {
    final url = Uri.parse(Env.registrationWebhookUrl);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email}),
    );

    return response.statusCode == 200;
  }
}
