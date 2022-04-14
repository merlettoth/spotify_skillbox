// Package imports:
import 'package:dio/dio.dart';

class NapsterApiClient {
  final Dio _dio;
  final String _baseUrl;
  final String _apiKey;

  NapsterApiClient(
    this._dio,
    this._baseUrl,
    this._apiKey,
  ) {
    _dio.options.headers['apikey'] = _apiKey;
  }

  Future<Response<Map<String, dynamic>>> getData({
    required String path,
    required Map<String, dynamic> params,
  }) {
    return _dio.get<Map<String, dynamic>>('$_baseUrl$path', queryParameters: params);
  }

  Future<Response<Map<String, dynamic>>> getPhotoData({
    required String path,
  }) {
    return _dio.get<Map<String, dynamic>>(path);
  }
}
