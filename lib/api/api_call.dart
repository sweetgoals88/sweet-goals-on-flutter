import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_prefs_cookie_store/shared_prefs_cookie_store.dart';

class APICall {
  final Dio _dio;

  static final APICall _instance = APICall._internal();
  final SharedPrefCookieStore _cookieStore = SharedPrefCookieStore();

  factory APICall() => _instance;

  APICall._internal() : _dio = Dio() {
    init();
  }

  void init() async {
    _dio.interceptors.add(CookieManager(_cookieStore));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Sending request to ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Received response: $response');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print('Error occurred: $error');
          return handler.next(error);
        },
      ),
    );
  }

  void clearCookies() {
    _cookieStore.deleteAll();
  }

  Dio get client => _dio;
}