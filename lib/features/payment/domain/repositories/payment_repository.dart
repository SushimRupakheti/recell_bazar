import 'package:flutter/material.dart';
import '../entities/payment_request.dart';

abstract class PaymentRepository {
  /// Initiates payment flow using the provided [request].
  /// [context] is used to show UI feedback (snackbars, dialogs) when necessary.
  Future<void> initiatePayment(PaymentRequest request, BuildContext context);
}
