import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
import '../../domain/entities/payment_request.dart';
import '../models/payment_model.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';

class PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio();

  String backendHost() {
    // Use ApiEndpoints.baseUrl, strip trailing '/api' for correct host
    final url = ApiEndpoints.baseUrl;
    return url.endsWith('/api') ? url.substring(0, url.length - 4) : url;
  }

  Future<Map<String, dynamic>> createCheckout(PaymentRequest request) async {
    final uri = Uri.parse('${backendHost()}/api/payments/stripe/checkout');
    final model = PaymentModel.fromRequest(request);
    if (kDebugMode) debugPrint('PaymentRemoteDataSource.createCheckout request: ${model.toJson()}');
    final resp = await _dio.postUri(uri, data: model.toJson());
    if (kDebugMode) debugPrint('PaymentRemoteDataSource.createCheckout response: ${resp.data}');
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      if (resp.data is Map<String, dynamic>) return resp.data as Map<String, dynamic>;
      return {'result': resp.data};
    }
    throw Exception('Payment init failed: ${resp.statusCode}');
  }
}
