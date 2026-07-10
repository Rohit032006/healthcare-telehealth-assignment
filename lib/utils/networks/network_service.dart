import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:healthcare/utils/extension/sized_box_extension.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart' as http_parser;
import '../constants/local_storage_key_strings.dart';
import '../dependency_locator.dart';
import 'app_interceptor.dart';
import 'end_point.dart';

class NetworkService {
  NetworkService() {
    _dio = Dio(
      _getOptions(),
    )..interceptors.addAll({appInterceptor});
  }
  AppInterceptor appInterceptor = getIt();
  late Dio _dio;
  final String _baseUrl = EndPoint.appBaseUrl;

  void updateAuthToken(String token) {
    final cleanToken = token.startsWith('Bearer ') ? token.substring(7) : token;
    _dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $cleanToken';
  }
  
  BaseOptions _getOptions() => BaseOptions(
        headers: _getHeaders(),
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      );

  Map<String, String?> _getHeaders() {
    Map<String, String?> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.userAgentHeader: 'dio',
      'app': 'office_book',
    };

    String accessToken = GetStorage().read(LocalStorageKeyStrings.accessToken) ?? '';

    if (accessToken.isNotEmpty) {
      final cleanToken = accessToken.startsWith('Bearer ') ? accessToken.substring(7) : accessToken;
      headers[HttpHeaders.authorizationHeader] = 'Bearer $cleanToken';
    } 

    return headers;
  }

  Future<dynamic> getRequest(
    String url, {
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    bool unauthorizedFallback = false,
  }) async {
    // Create a new Dio instance with or without the interceptor based on unauthorizedFallback
    final dioInstance = _createDioInstance(unauthorizedFallback);
    
    Uri endpoint = Uri.https(baseUrl ?? _baseUrl, url, queryParameters);
    Uri.decodeQueryComponent(endpoint.toString());
    Response response = await dioInstance.getUri(endpoint);
    return response.data;
  }

  Future<dynamic> postRequest(
    String url, {
    Map<String, dynamic>? body,
    String? baseUrl,
    bool unauthorizedFallback = false,
  }) async {
    // Create a new Dio instance with or without the interceptor based on unauthorizedFallback
    final dioInstance = _createDioInstance(unauthorizedFallback);
    
    Uri endpoint = Uri.https(
      baseUrl ?? _baseUrl,
      url,
    );

    Response response = await dioInstance.postUri(endpoint, data: body ?? {});

    if (response.data?.isNotEmpty ?? false) {
      return response.data;
    }

    return null;
  }
Future<List<int>?> getPdfRequest(
    String url, {
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    bool unauthorizedFallback = false,
  }) async {
    final dioInstance = _createDioInstance(unauthorizedFallback);
    Uri endpoint = Uri.https(baseUrl ?? _baseUrl, url, queryParameters);
    Uri.decodeQueryComponent(endpoint.toString());
    Response response = await dioInstance.getUri(
      endpoint,
      options: Options(
        responseType: ResponseType.bytes,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 200 && response.data != null) {
      return response.data as List<int>;
    }
    return null;
  }

  Future<dynamic> postFileRequest(
    String url, {
    String? baseUrl,
    required String filePath,
    Function(double progress)? onProgress,
    Map<String, dynamic>? extraBody,
    bool unauthorizedFallback = false,
  }) async {
    try {
      // Create a separate Dio instance for file uploads
      final uploadDio = Dio(BaseOptions(
        baseUrl: 'https://${baseUrl ?? _baseUrl}',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ));
      
      // Add interceptors based on unauthorizedFallback
      if (!unauthorizedFallback) {
        uploadDio.interceptors.add(appInterceptor);
      }
      
      // Create a custom logging interceptor that handles FormData
      uploadDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Don't log FormData content as it contains binary data
            if (options.data is FormData) {
            } else {
            }
            
            handler.next(options);
          },
          onResponse: (response, handler) {
            handler.next(response);
          },
          onError: (error, handler) {
            handler.next(error);
          },
        ),
      );
      
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception("File does not exist");
      }

      // Get access token
      String accessToken = GetStorage().read(LocalStorageKeyStrings.accessToken) ?? '';
      if (accessToken.isEmpty) {
        throw Exception("Access token not found");
      }
      final cleanToken = accessToken.startsWith('Bearer ') ? accessToken.substring(7) : accessToken;

      // Get proper filename and content type
      final fileName = file.path.split('/').last;
      final contentType = fileName.getContentType();
      
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          filePath, 
          filename: fileName,
          contentType: http_parser.MediaType.parse(contentType),
        ),
      });
      
      // Add extra body fields if provided
      if (extraBody != null) {
        formData.fields.addAll(
          extraBody.entries.map((entry) => MapEntry(entry.key, entry.value.toString())),
        );
      }

      Response response = await uploadDio.post(
        url, // Use relative URL since baseUrl is set
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $cleanToken',
            'Accept': '*/*',
            'Accept-Language': 'en-US,en;q=0.9',
            'app': 'office_book',
            // Don't set content-type manually - let Dio handle it
          },
          validateStatus: (status) => status != null && status < 500,
        ),
        onSendProgress: onProgress != null 
          ? (sent, total) {
              if (total > 0) {
                onProgress(sent / total);
              }
            }
          : null,
      );

      if (response.data?.isNotEmpty ?? false) {
        return response.data;
      }

      return null;
    } catch (e) {
      if (e is DioException) {
        // Handle error based on unauthorizedFallback
        if (e.response?.statusCode == 401 && unauthorizedFallback) {
          // Don't logout, just rethrow the exception
          rethrow;
        }
      }
      rethrow;
    }
  }

  Future<dynamic> putRequest(
    String url, {
    Map<String, dynamic>? body,
    String? baseUrl,
    bool unauthorizedFallback = false,
  }) async {
    // Create a new Dio instance with or without the interceptor based on unauthorizedFallback
    final dioInstance = _createDioInstance(unauthorizedFallback);
    
    Uri endpoint = Uri.https(baseUrl ?? _baseUrl, url);
    Response response = await dioInstance.putUri(endpoint, data: body ?? {});

    return response.data;
  }

  Future<dynamic> deleteRequest(
    String url, {
    Map<String, dynamic>? body,
    String? baseUrl,
    bool unauthorizedFallback = false,
  }) async {
    try {
      // Create a new Dio instance with or without the interceptor based on unauthorizedFallback
      final dioInstance = _createDioInstance(unauthorizedFallback);
      
      Uri endpoint = Uri.https(baseUrl ?? _baseUrl, url);
      
      Response response = await dioInstance.deleteUri(endpoint);
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to create Dio instance with appropriate interceptors
  Dio _createDioInstance(bool unauthorizedFallback) {
    final dioInstance = Dio(_getOptions());
    
    // Always add logging interceptor
    dioInstance.interceptors.add(Logging(dioInstance));
    
    // Add app interceptor only if unauthorizedFallback is false
    if (!unauthorizedFallback) {
      dioInstance.interceptors.add(appInterceptor);
    }
    
    return dioInstance;
  }

  Future<dynamic> postFormDataRequest(
  String url, {
  String? baseUrl,
  required Map<String, dynamic> data,
  File? imageFile,
  bool unauthorizedFallback = false,
}) async {
  try {
    final uploadDio = Dio(BaseOptions(
      baseUrl: 'https://${baseUrl ?? _baseUrl}',
      connectTimeout: const Duration(seconds: 120), 
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    ));
    
    if (!unauthorizedFallback) {
      uploadDio.interceptors.add(appInterceptor);
    }

    String accessToken = GetStorage().read(LocalStorageKeyStrings.accessToken) ?? '';
    if (accessToken.isEmpty) {
      throw Exception("Access token not found");
    }
    final cleanToken = accessToken.startsWith('Bearer ') ? accessToken.substring(7) : accessToken;

    final formData = FormData();
    
    formData.fields.add(MapEntry('data', jsonEncode(data)));
    
    if (imageFile != null && imageFile.existsSync()) {
      final fileName = imageFile.path.split('/').last;
      
      String contentType = 'image/jpeg'; 
      if (fileName.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.toLowerCase().endsWith('.jpg') || 
                 fileName.toLowerCase().endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      }
      
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: http_parser.MediaType.parse(contentType),
        ),
      ));
      
    }


    Response response = await uploadDio.post(
      url,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $cleanToken',
          'Accept': '*/*',
          'Accept-Language': 'en-US,en;q=0.9',
          'app': 'office_book',
        },
        validateStatus: (status) => status != null && status < 500,
        followRedirects: false,
      ),
      onSendProgress: (sent, total) {
        if (total > 0) {
          (sent / total * 100).toStringAsFixed(0);
        }
      },
    );

    if (response.statusCode == null || response.statusCode! < 200 || response.statusCode! >= 300) {
      String errorMsg = 'Request failed with status ${response.statusCode}';
      
      if (response.data is Map) {
        errorMsg = response.data['error'] ?? 
                   response.data['message'] ?? 
                   response.data['detail'] ??
                   errorMsg;
      } else if (response.data is String) {
        errorMsg = response.data;
      }
      
      throw Exception(errorMsg);
    }

    if (response.data is Map) {
      final map = response.data as Map<String, dynamic>;
      if (map['success'] == false || (map['error'] != null && map['error'].toString().isNotEmpty)) {
        final errorMsg = map['error'] ?? map['message'] ?? 'Request failed';
        throw Exception(errorMsg);
      }
    }

    return response.data;

  } catch (e) {
    
    if (e is DioException) {
      
      if (e.response?.statusCode == 401 && unauthorizedFallback) {
        rethrow;
      }
      
      String errorMsg = 'Network error occurred';
      if (e.response?.data is Map) {
        errorMsg = e.response!.data['error'] ?? 
                   e.response!.data['message'] ?? 
                   e.response!.data['detail'] ??
                   errorMsg;
      } else if (e.response?.data is String) {
        errorMsg = e.response!.data;
      } else if (e.message != null) {
        errorMsg = e.message!;
      }
      
      throw Exception(errorMsg);
    }
    
    rethrow;
  }
}

}