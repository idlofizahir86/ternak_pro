class HealthResponse {
  final String laravel;           // 'healthy'
  final String pythonAiService;   // 'healthy' | 'unhealthy'
  final dynamic pythonResponse;   // object dari /health Python (bisa Map)

  HealthResponse({
    required this.laravel,
    required this.pythonAiService,
    required this.pythonResponse,
  });

  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      laravel: json['laravel']?.toString() ?? '',
      pythonAiService: json['python_ai_service']?.toString() ?? '',
      pythonResponse: json['python_response'],
    );
  }
}