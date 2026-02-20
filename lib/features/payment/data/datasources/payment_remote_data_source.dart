import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../domain/entities/payment_request.dart';
import '../models/payment_model.dart';

class PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSource({Dio? dio}) : _dio = dio ?? Dio();

  String backendHost() {
    if (kIsWeb) return 'http://localhost:5050';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:5050';
      if (Platform.isIOS) return 'http://localhost:5050';
    } catch (_) {}
    return 'http://localhost:5050';
  }

  Future<Map<String, dynamic>> createCheckout(PaymentRequest request) async {
    final uri = Uri.parse('${backendHost()}/api/payments/stripe/checkout');
    final model = PaymentModel.fromRequest(request);
    final resp = await _dio.postUri(uri, data: model.toJson());
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      if (resp.data is Map<String, dynamic>) return resp.data as Map<String, dynamic>;
      return {'result': resp.data};
    }
    throw Exception('Payment init failed: ${resp.statusCode}');
  }
}
