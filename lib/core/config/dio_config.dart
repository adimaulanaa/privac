// File: lib/core/network/dio_config.dart
import 'package:dio/dio.dart';
import 'package:privac/core/config/base_config.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: BaseConfig.baseUrl, // Ganti dengan URL yang sesuai
      connectTimeout: const Duration(seconds: BaseConfig.timeOutServer),
      receiveTimeout: const Duration(seconds: BaseConfig.timeOutServer),
      headers: BaseConfig.headers,
    ),
  );
  return dio;
}
