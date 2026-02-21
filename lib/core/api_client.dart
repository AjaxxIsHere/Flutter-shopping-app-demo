import 'package:dio/dio.dart';

// Singleton API client with logging interceptor for debugging 
// Params: - baseUrl: https://fakestoreapi.com
//         - connectTimeout: 10s
//         - receiveTimeout: 10s
class ApiClient {
  ApiClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )
    ..interceptors.add(LogInterceptor(request: true, requestBody: true, responseBody: true));
}
