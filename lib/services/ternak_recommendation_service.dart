// lib/services/ternak_recommendation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/HealtResponse.dart';
import '../models/TernakRecommendationResponse.dart';

class TernakRecommendationService {
  static const String _baseUrl = 'https://ternakpro.id/api/v1';
  static const Duration _timeout = Duration(seconds: 30);

  // ====== Helpers ======
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // null jika belum login
  }

  static Future<Map<String, String>> _headers() async {
    final token = await _getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ====== Health Check ======
  static Future<HealthResponse> healthCheck() async {
    final uri = Uri.parse('$_baseUrl/ai/rekomendasi-ternak/health');
    final res = await http.get(uri, headers: await _headers()).timeout(_timeout);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final jsonMap = jsonDecode(res.body) as Map<String, dynamic>;
      return HealthResponse.fromJson(jsonMap);
    } else {
      throw TernakApiException(
        message: 'Gagal memeriksa kesehatan service',
        statusCode: res.statusCode,
        body: res.body,
      );
    }
  }

  // ====== Get Recommendation ======
  /// Kirim data sesuai validasi controller Laravel:
  /// region, land_length, land_width, goal (daging|telur|susu|bibit|lainnya),
  /// available_feed (array string), time_availability (pagi|siang|sore|sepanjang_hari),
  /// experience (pemula|menengah|ahli)
  static Future<TernakRecommendationResponse> getRecommendation({
    required String region,
    required num landLength,
    required num landWidth,
    required String goal,
    required List<String> availableFeed,
    required String timeAvailability,
    required String experience,
  }) async {
    final uri = Uri.parse('$_baseUrl/ai/rekomendasi-ternak');
    final payload = {
      'region': region,
      'land_length': landLength,
      'land_width': landWidth,
      'goal': goal,
      'available_feed': availableFeed,
      'time_availability': timeAvailability,
      'experience': experience,
    };

    final res = await http
        .post(uri, headers: await _headers(), body: jsonEncode(payload))
        .timeout(_timeout);

    final bodyStr = res.body.isEmpty ? '{}' : res.body;
    final jsonMap = jsonDecode(bodyStr) as Map<String, dynamic>;

    // Laravel controller mengembalikan:
    // - 200: { success: true, data: {...} }
    // - 422: { success: false, message, errors: {...} }
    // - 503/500: { success: false, message }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final success = jsonMap['success'] == true;
      if (!success) {
        throw TernakApiException(
          message: jsonMap['message']?.toString() ?? 'Gagal mendapatkan rekomendasi',
          statusCode: res.statusCode,
          body: res.body,
        );
      }
      return TernakRecommendationResponse.fromJson(jsonMap['data'] as Map<String, dynamic>);
    } else if (res.statusCode == 422) {
      throw TernakValidationException(
        message: jsonMap['message']?.toString() ?? 'Validasi gagal',
        errors: (jsonMap['errors'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, List<String>.from(v as List)),
            ) ??
            {},
      );
    } else {
      throw TernakApiException(
        message: jsonMap['message']?.toString() ?? 'Terjadi kesalahan pada AI service',
        statusCode: res.statusCode,
        body: res.body,
      );
    }
  }
}

// ====== Exceptions ======
class TernakApiException implements Exception {
  final String message;
  final int statusCode;
  final String body;
  TernakApiException({required this.message, required this.statusCode, required this.body});
  @override
  String toString() => 'TernakApiException($statusCode): $message\n$body';
}

class TernakValidationException implements Exception {
  final String message;
  final Map<String, List<String>> errors;
  TernakValidationException({required this.message, required this.errors});
  @override
  String toString() => 'TernakValidationException: $message\n$errors';
}
