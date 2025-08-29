import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String baseUrl = 'https://aquamarine-ferret-962895.hostingersite.com/api/v1';
  
  String? authToken;

  ChatService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token');
  }

  // Kirim pesan ke AI
  // Di ChatService, tambahkan timeout dan error handling
Future<Map<String, dynamic>> sendMessage({
  required String userId,
  required String message,
  int? conversationId,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/chat'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({
        'user_id': userId,
        'message': message,
        'conversation_id': 1,
      }),
    ).timeout(Duration(seconds: 30)); // Timeout 30 detik

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      // Token expired, redirect to login
      throw Exception('Session expired. Please login again.');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw Exception('Network error: $e');
  } on TimeoutException catch (e) {
    throw Exception('Request timeout: $e');
  }
}

  // Mulai percakapan baru
  Future<Map<String, dynamic>> startNewConversation(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/chat/new'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to start new conversation');
    }
  }

  // Dapatkan semua percakapan user
  Future<List<dynamic>> getConversations(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ai/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load conversations');
    }
  }

  // Dapatkan percakapan spesifik
  Future<Map<String, dynamic>> getConversation(String userId, int conversationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ai/conversation/$userId/$conversationId'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load conversation');
    }
  }

  // Hapus percakapan
  Future<void> deleteConversation(String userId, int conversationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ai/conversation/$userId/$conversationId'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete conversation');
    }
  }
}