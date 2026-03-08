import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recell_bazar/features/payment/domain/entities/payment_request.dart';
import 'package:recell_bazar/features/payment/domain/repositories/payment_repository.dart';
import 'package:recell_bazar/features/payment/domain/usecases/initiate_payment_usecase.dart';
import 'package:recell_bazar/features/payment/presentation/providers/payment_provider.dart';

class FakePaymentRepository implements PaymentRepository {
  int callCount = 0;
  PaymentRequest? lastRequest;
  BuildContext? lastContext;

  @override
  Future<void> initiatePayment(PaymentRequest request, BuildContext context) async {
    callCount++;
    lastRequest = request;
    lastContext = context;
  }
}

PaymentRequest buildRequest() {
  return PaymentRequest(
    amount: 1000,
    productName: 'Phone',
    productId: 'prod-1',
    buyerName: 'Buyer',
    customerEmail: 'buyer@test.com',
    buyerPhone: '9800000000',
    orderId: 'order-1',
    fullName: 'Buyer Name',
    phoneNo: '9800000000',
    phoneModel: 'iPhone 13',
    sellerId: 'seller-1',
    price: 1000,
    location: 'Kathmandu',
    date: '2026-03-08',
    time: '10:00',
    oid: 'oid-1',
    refId: 'ref-1',
  );
}

void main() {
  Widget appWithProvider(Widget child, dynamic overrides) {
    return ProviderScope(
      overrides: [for (final o in (overrides as List)) o],
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('paymentControllerProvider provides PaymentController', (tester) async {
    late PaymentController controller;

    await tester.pumpWidget(
      appWithProvider(
        Consumer(
          builder: (context, ref, _) {
            controller = ref.watch(paymentControllerProvider);
            return const SizedBox();
          },
        ),
        const [],
      ),
    );

    expect(controller, isA<PaymentController>());
  });

  testWidgets('controller uses overridden initiate usecase instance', (tester) async {
    final fakeRepo = FakePaymentRepository();
    final fakeUsecase = InitiatePaymentUseCase(fakeRepo);
    late PaymentController controller;

    await tester.pumpWidget(
      appWithProvider(
        Consumer(
          builder: (context, ref, _) {
            controller = ref.watch(paymentControllerProvider);
            return const SizedBox();
          },
        ),
        [
          initiatePaymentUseCaseProvider.overrideWithValue(fakeUsecase),
        ],
      ),
    );

    expect(identical(controller.usecase, fakeUsecase), isTrue);
  });

  testWidgets('tapping button calls initiatePayment through controller', (tester) async {
    final fakeRepo = FakePaymentRepository();
    final fakeUsecase = InitiatePaymentUseCase(fakeRepo);
    final request = buildRequest();

    await tester.pumpWidget(
      appWithProvider(
        Consumer(
          builder: (context, ref, _) {
            final controller = ref.watch(paymentControllerProvider);
            return ElevatedButton(
              onPressed: () => controller.initiatePayment(context, request),
              child: const Text('Pay'),
            );
          },
        ),
        [
          initiatePaymentUseCaseProvider.overrideWithValue(fakeUsecase),
        ],
      ),
    );

    await tester.tap(find.text('Pay'));
    await tester.pump();

    expect(fakeRepo.callCount, 1);
  });

  testWidgets('request values are forwarded to repository', (tester) async {
    final fakeRepo = FakePaymentRepository();
    final fakeUsecase = InitiatePaymentUseCase(fakeRepo);
    final request = buildRequest();

    await tester.pumpWidget(
      appWithProvider(
        Consumer(
          builder: (context, ref, _) {
            final controller = ref.watch(paymentControllerProvider);
            return ElevatedButton(
              onPressed: () => controller.initiatePayment(context, request),
              child: const Text('Start Payment'),
            );
          },
        ),
        [
          initiatePaymentUseCaseProvider.overrideWithValue(fakeUsecase),
        ],
      ),
    );

    await tester.tap(find.text('Start Payment'));
    await tester.pump();

    expect(fakeRepo.lastRequest?.orderId, 'order-1');
    expect(fakeRepo.lastRequest?.amount, 1000);
    expect(fakeRepo.lastRequest?.sellerId, 'seller-1');
  });

  testWidgets('build context is forwarded to repository', (tester) async {
    final fakeRepo = FakePaymentRepository();
    final fakeUsecase = InitiatePaymentUseCase(fakeRepo);
    final request = buildRequest();

    await tester.pumpWidget(
      appWithProvider(
        Consumer(
          builder: (context, ref, _) {
            final controller = ref.watch(paymentControllerProvider);
            return ElevatedButton(
              onPressed: () => controller.initiatePayment(context, request),
              child: const Text('Checkout'),
            );
          },
        ),
        [
          initiatePaymentUseCaseProvider.overrideWithValue(fakeUsecase),
        ],
      ),
    );

    await tester.tap(find.text('Checkout'));
    await tester.pump();

    expect(fakeRepo.lastContext, isNotNull);
  });
}
