import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project/main.dart';
import 'package:graduation_project/views/login.dart';

class ApiClient {
  // ✅ Android Emulator  → use: http://10.0.2.2:5000/api
  // ✅ Real Device (WiFi) → use: http://192.168.1.2:5000/api
  // ✅ iOS Simulator     → use: http://localhost:5000/api
  static const String _baseUrl =
      'http://107.21.214.224:8080/api'; // AWS EC2 Instance (Static Elastic IP)

  final Dio _dio;

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 200),
          receiveTimeout: const Duration(seconds: 200),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          final requestPath = e.requestOptions.path;
          if (e.response?.statusCode == 401 && !requestPath.contains('/auth/login')) {
            final context = MyApp.navigatorKey.currentContext;
            final navState = MyApp.navigatorKey.currentState;

            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('auth_token');
            await prefs.remove('user_data');
            
            if (context != null && navState != null && context.mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('انتهت الجلسة', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                  content: const Text(
                    'الرجاء تسجيل الدخول مرة أخرى لمتابعة استخدام التطبيق.',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          navState.pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        },
                        child: const Text('موافق', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return handler.next(e);
        },
      ),
    );
    _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
          maxWidth: 90,
        ),
      );
  }

  Dio get dio => _dio;
}
