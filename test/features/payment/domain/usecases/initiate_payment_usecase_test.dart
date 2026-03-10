import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recell_bazar/features/payment/domain/entities/payment_request.dart';
import 'package:recell_bazar/features/payment/domain/repositories/payment_repository.dart';
import 'package:recell_bazar/features/payment/domain/usecases/initiate_payment_usecase.dart';

class MockBuildContext extends Mock implements BuildContext {}

class FakePaymentRepository implements PaymentRepository {
  int callCount = 0;
  PaymentRequest? lastRequest;
  BuildContext? lastContext;
  Object? errorToThrow;

  @override
  Future<void> initiatePayment(PaymentRequest request, BuildContext context) async {
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    callCount++;
    lastRequest = request;
    lastContext = context;
  }
}

PaymentRequest buildRequest({
  String orderId = 'order-1',
  int amount = 1000,
}) {
  return PaymentRequest(
    amount: amount,
    productName: 'Phone',
    productId: 'p-1',
    buyerName: 'Buyer',
    customerEmail: 'buyer@test.com',
    buyerPhone: '9800000000',
    orderId: orderId,
    fullName: 'Buyer Name',
    phoneNo: '9800000000',
    phoneModel: 'iPhone 13',
    sellerId: 'seller-1',
    price: amount,
    location: 'Kathmandu',
    date: '2026-03-08',
    time: '10:00',
    oid: 'oid-1',
    refId: 'ref-1',
  );
}

void main() {
  late FakePaymentRepository repository;
  late InitiatePaymentUseCase usecase;
  late BuildContext context;

  setUp(() {
    repository = FakePaymentRepository();
    usecase = InitiatePaymentUseCase(repository);
    context = MockBuildContext();
  });

  test('1) calls repository exactly once', () async {
    final request = buildRequest();

    await usecase.call(request, context);

    expect(repository.callCount, 1);
  });

  test('2) forwards the same PaymentRequest instance', () async {
    final request = buildRequest(orderId: 'order-77');

    await usecase.call(request, context);

    expect(identical(repository.lastRequest, request), isTrue);
    expect(repository.lastRequest?.orderId, 'order-77');
  });

  test('3) forwards the same BuildContext instance', () async {
    final request = buildRequest();

    await usecase.call(request, context);

    expect(identical(repository.lastContext, context), isTrue);
  });

  test('4) propagates repository exceptions', () async {
    final request = buildRequest();
    repository.errorToThrow = Exception('payment failed');

    expect(
      () => usecase.call(request, context),
      throwsA(isA<Exception>()),
    );
  });

  test('5) supports multiple sequential invocations', () async {
    final req1 = buildRequest(orderId: 'order-1', amount: 1000);
    final req2 = buildRequest(orderId: 'order-2', amount: 2000);

    await usecase.call(req1, context);
    await usecase.call(req2, context);

    expect(repository.callCount, 2);
    expect(repository.lastRequest?.orderId, 'order-2');
    expect(repository.lastRequest?.amount, 2000);
  });
}
