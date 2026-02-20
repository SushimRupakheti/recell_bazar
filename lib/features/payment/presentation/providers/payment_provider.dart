import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/payment_remote_data_source.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/usecases/initiate_payment_usecase.dart';
import '../../domain/entities/payment_request.dart';

final paymentRemoteDataSourceProvider = Provider((ref) => PaymentRemoteDataSource());

final paymentRepositoryProvider = Provider<PaymentRepositoryImpl>((ref) => PaymentRepositoryImpl(remote: ref.read(paymentRemoteDataSourceProvider)));

final initiatePaymentUseCaseProvider = Provider((ref) => InitiatePaymentUseCase(ref.read(paymentRepositoryProvider)));

class PaymentController {
  final InitiatePaymentUseCase usecase;

  PaymentController(this.usecase);

  Future<void> initiatePayment(BuildContext context, PaymentRequest request) async {
    return usecase.call(request, context);
  }
}

final paymentControllerProvider = Provider((ref) => PaymentController(ref.read(initiatePaymentUseCaseProvider)));
