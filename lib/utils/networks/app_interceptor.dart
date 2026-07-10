import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../constants/local_storage_key_strings.dart';
import '../dependency_locator.dart';
import 'api_logger.dart';
import 'end_point.dart';
import 'network_service.dart';
import 'package:get/get.dart' as get_x;
import '../../features/login/model/login_response.dart';
import '../../features/bottom_nav_bar/controller/bottom_nav_bar_controller.dart';

enum RefreshTokenStatus { active, expired, fail, pending }

enum ErrorCheckResults { end, retry, next, renewSession }

class AppInterceptor extends Interceptor {
  AppInterceptor(
    this._baseUrl, {
    this.skipUnauthorizedHandler = false,
  });

  final String _baseUrl;
  final bool skipUnauthorizedHandler;

  // Shared future to synchronize concurrent token refreshes
  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // You can add the skipUnauthorizedHandler flag to request options
    // so it can be accessed in other interceptor methods
    options.extra['skipUnauthorizedHandler'] = skipUnauthorizedHandler;
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    Response? response = err.response;
    
    // Check if we should skip unauthorized handling
    final skipHandler = err.requestOptions.extra['skipUnauthorizedHandler'] as bool? ?? false;
    if (err.response?.statusCode == 401) {
      // If skipUnauthorizedHandler is true, don't perform logout
      if (skipHandler) {
        handler.next(err);
        return;
      }

      String? newAccessToken;

      if (_refreshFuture != null) {
        log("AppInterceptor: Refresh token is already in progress, awaiting existing request");
        newAccessToken = await _refreshFuture;
      } else {
        // Fetch login response from storage
        Map<String, dynamic> loginResp = GetStorage().read(LocalStorageKeyStrings.loginResp) ?? {};
        if (loginResp.isEmpty) {
          log("AppInterceptor: No login response in storage, logging out");
          logout();
          handler.next(err);
          return;
        }


        final loginResponse = LoginResponse.fromJson(loginResp);
        final refreshToken = loginResponse.refreshToken ?? '';
        if (refreshToken.isEmpty) {
          log("AppInterceptor: No refresh token in login response, logging out");
          logout();
          handler.next(err);
          return;
        }

        log("AppInterceptor: Initiating single refresh token API call");
        _refreshFuture = onRequireRefreshAccessToken(response, refreshToken);
        newAccessToken = await _refreshFuture;
        _refreshFuture = null;
      }

      if (newAccessToken != null) {
        log("AppInterceptor: Token refresh succeeded, retrying request with new token");
        try {
          // Prepare refreshed request
          final requestOptions = err.response!.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final dioRefresh = Dio(
            BaseOptions(
              baseUrl: requestOptions.baseUrl,
              headers: <String, String>{'accept': 'application/json'},
            ),
          );

          final response = await dioRefresh.request<dynamic>(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
            ),
          );

          return handler.resolve(response);
        } on DioException catch (e) {
          if (e.response?.statusCode == 401) {
            log("AppInterceptor: Retried request returned 401, logging out");
            logout();
          }
          handler.next(e);
          return;
        } catch (e) {
          handler.next(err);
          return;
        }
      } else {
        log("AppInterceptor: Token refresh failed, logging out and rejecting request");
        logout();
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }

  Future<String?> onRequireRefreshAccessToken(Response? response, String refreshToken) async {
    try {
      const refreshTokenUrl = EndPoint.refreshTokenUrl;

      // Call the API to get a new token
      Uri uri = Uri.https(_baseUrl, refreshTokenUrl);
      final resp = await Dio().postUri(uri, data: {
        'refresh_token': refreshToken,
      });

      // Get new refresh token and access token (supporting both correct and misspelled keys)
      final newRefreshToken = resp.data['refresh_token'];
      final accessToken = resp.data['access_token'] ?? resp.data['assess_token'];

      if (newRefreshToken != null) {
        GetStorage().write(LocalStorageKeyStrings.refreshToken, newRefreshToken);
      }

      if (accessToken != null) {
        GetStorage().write(LocalStorageKeyStrings.accessToken, accessToken);
        try {
          final NetworkService service = getIt<NetworkService>();
          service.updateAuthToken(accessToken);
        } catch (e) {
          log('AppInterceptor: Could not update NetworkService auth token: $e');
        }
      }

      // Keep loginResp in storage synchronized so subsequent triggers use the updated refresh token
      Map<String, dynamic> loginResp = GetStorage().read(LocalStorageKeyStrings.loginResp) ?? {};
      if (loginResp.isNotEmpty) {
        final loginResponse = LoginResponse.fromJson(loginResp);
        if (accessToken != null) {
          loginResponse.accessToken = accessToken;
        }
        if (newRefreshToken != null) {
          loginResponse.refreshToken = newRefreshToken;
        }
        GetStorage().write(LocalStorageKeyStrings.loginResp, loginResponse.toJson());
      }

      return accessToken;
    } catch (e, stack) {
      log('Error while refreshing token: $e\n$stack');
      return null;
    }
  }
}


bool _isLoggingOut = false;

Future<void> logout() async {
  if (_isLoggingOut) {
    log("logout: Already in progress, skipping duplicate call");
    return;
  }
  _isLoggingOut = true;
  log("logout starts");
  try {
    final storage = GetStorage();
    final clientId = storage.read(LocalStorageKeyStrings.clientId);
    final userId = storage.read(LocalStorageKeyStrings.loggedInUserId);


    var accessToken = storage.read(LocalStorageKeyStrings.accessToken);
    if (accessToken != null && accessToken.toString().startsWith("Bearer ")) {
      accessToken = accessToken.toString().replaceFirst("Bearer ", "");
    }
    
    if (clientId != null && userId != null && accessToken != null) {
      final baseUrl = EndPoint.appBaseUrl;
      final scheme = baseUrl.startsWith('http') ? '' : 'https://';
      final deleteTokenUrl = '$scheme$baseUrl/auth/api/firebase-tokens/client/$clientId/user/$userId?platform=app&app_id=${EndPoint.appId}';
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.delete(deleteTokenUrl);
      log("Firebase token deleted: ${response.data}");
    }
  } catch (e) {
    log("Error deleting firebase token on logout: $e");
  } finally {
    try {
      await GetStorage().erase();
      get_x.Get.delete<BottomNavBarController>(force: true);  
      await get_x.Get.deleteAll(force: true);
    } catch (e) {
      log("Error clearing storage or deleting Get controllers: $e");
    }

    try {
      final context = LocalStorageKeyStrings.appNavKey.currentContext;
      if (context != null && context.mounted) {
        context.go('/');
      } else {
        log("Navigator context is not available or not mounted for logout navigation.");
      }
    } catch (e) {
      log("Error navigating to login page: $e");
    }
    _isLoggingOut = false;
  }
}

class Logging extends Interceptor {
  final Dio dio;

  Logging(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ApiLogger.logDioRequest(options);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ApiLogger.logDioResponse(response);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiLogger.logDioError(err);
    return super.onError(err, handler);
  }
}