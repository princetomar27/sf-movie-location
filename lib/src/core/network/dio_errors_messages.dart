import 'package:dio/dio.dart';

Future<Response> performRequestWithRetry(String baseUrl, String apiKey) async {
  int retryCount = 0;
  const int maxRetries = 3;
  const Duration retryDelay = Duration(seconds: 2);

  while (true) {
    try {
      return await Dio().get(
        baseUrl,
        options: Options(headers: {'X-App-Token': apiKey}),
      );
    } on DioException catch (e) {
      if (_shouldRetry(e) && retryCount < maxRetries) {
        retryCount++;
        await Future.delayed(retryDelay);
      } else {
        rethrow;
      }
    }
  }
}

/// **Determines if a request should be retried based on the error type**
bool _shouldRetry(DioException e) {
  return e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.response?.statusCode == 500; // Retry on server errors
}

/// Enhanced Dio error mapping
String mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      return 'Connection timeout. Please check your internet connection.';
    case DioExceptionType.sendTimeout:
      return 'Request timeout. Please try again.';
    case DioExceptionType.receiveTimeout:
      return 'Server response timeout. Please try again later.';
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      return 'Server error: ${statusCode ?? 'Unknown status code'}';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    case DioExceptionType.unknown:
      return 'Unknown network error: ${e.message}';
    default:
      return 'An unexpected error occurred: ${e.message}';
  }
}
