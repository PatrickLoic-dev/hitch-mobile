import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

class ApiClient {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // You can handle responses here
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // You can handle errors here, e.g., token refresh
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
