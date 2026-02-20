import 'package:flutter/material.dart';
import '../entities/payment_request.dart';
import '../repositories/payment_repository.dart';

class InitiatePaymentUseCase {
  final PaymentRepository repository;

  InitiatePaymentUseCase(this.repository);

  Future<void> call(PaymentRequest request, BuildContext context) async {
    return repository.initiatePayment(request, context);
  }
}
