import '../../domain/entities/payment_request.dart';

class PaymentModel {
  final PaymentRequest request;

  PaymentModel(this.request);

  Map<String, dynamic> toJson() => request.toMap();

  factory PaymentModel.fromRequest(PaymentRequest req) => PaymentModel(req);
}
