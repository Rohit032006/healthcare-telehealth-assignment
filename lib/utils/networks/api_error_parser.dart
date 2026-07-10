import 'package:dio/dio.dart';

class ApiErrorParser {
  ApiErrorParser._();

  static String extractMessage(dynamic error, {String fallback = 'Something went wrong'}) {
    try {
      if (error is DioException) {
        final res = error.response;
        final data = res?.data;
        
        if (data is Map<String, dynamic>) {
          final msg = _fromMap(data);
          if (msg.isNotEmpty) return msg;
        }
        
        if (data is List && data.isNotEmpty) {
          final first = data.first;
          if (first is Map<String, dynamic>) {
            final msg = _fromMap(first);
            if (msg.isNotEmpty) return msg;
          } else if (first is String) {
            return first;
          }
        }
        
        if (data is String && data.trim().isNotEmpty) {
          return data.trim();
        }
        
        if (res?.statusMessage != null && res!.statusMessage!.isNotEmpty) {
          return res.statusMessage!;
        }
        
        if (error.message != null && error.message!.isNotEmpty) {
          final cleanMessage = _cleanDioExceptionMessage(error.message!);
          if (cleanMessage.isNotEmpty) return cleanMessage;
        }
        
        if (res?.statusCode != null) {
          return _getGenericErrorMessage(res!.statusCode!);
        }
      }
      
      if (error is Map<String, dynamic>) {
        final msg = _fromMap(error);
        if (msg.isNotEmpty) return msg;
      }
      
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    } catch (_) {}
    return fallback;
  }

  static String _fromMap(Map<String, dynamic> map) {
    for (final key in const ['error', 'message', 'detail', 'msg']) {
      final v = map[key];
      if (v is String && v.trim().isNotEmpty) return v.trim();
      if (v is Map<String, dynamic>) {
        final nested = _fromMap(v);
        if (nested.isNotEmpty) return nested;
      }
    }
    if (map['errors'] is List && (map['errors'] as List).isNotEmpty) {
      final first = (map['errors'] as List).first;
      if (first is String) return first;
      if (first is Map<String, dynamic>) {
        for (final entry in first.entries) {
          final val = entry.value;
          if (val is List && val.isNotEmpty) {
            final firstMsg = val.first;
            if (firstMsg is String) return firstMsg;
          }
          if (val is String && val.isNotEmpty) return val;
        }
      }
    }
    return '';
  }

  static String _cleanDioExceptionMessage(String message) {
    String cleaned = message;
    
    if (cleaned.startsWith('DioException [')) {
      final startIndex = cleaned.indexOf(']: ');
      if (startIndex != -1) {
        cleaned = cleaned.substring(startIndex + 3);
      }
    }
    
    final technicalPatterns = [
      RegExp(r'RequestOptions\.validateStatus was configured to throw for this status code\.'),
      RegExp(r'The status code of \d+ has the following meaning:.*?Read more about status codes at.*?developer\.mozilla\.org.*?'),
      RegExp(r'In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code\.'),
      RegExp(r'Read more about status codes at.*?developer\.mozilla\.org.*?'),
    ];
    
    for (final pattern in technicalPatterns) {
      cleaned = cleaned.replaceAll(pattern, '').trim();
    }
    
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return cleaned;
  }

  static String _getGenericErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request - please check your input';
      case 401:
        return 'Unauthorized - please login again';
      case 403:
        return 'Forbidden - you don\'t have permission to perform this action';
      case 404:
        return 'Not found - the requested resource was not found';
      case 409:
        return 'Conflict - the request conflicts with the current state';
      case 422:
        return 'Validation error - please check your input';
      case 429:
        return 'Too many requests - please try again later';
      case 500:
        return 'Server error - please try again later';
      case 502:
        return 'Bad gateway - server is temporarily unavailable';
      case 503:
        return 'Service unavailable - please try again later';
      case 504:
        return 'Gateway timeout - request took too long';
      default:
        return 'An error occurred ($statusCode)';
    }
  }
}


