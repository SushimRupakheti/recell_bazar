import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/payment_request.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remote;

  PaymentRepositoryImpl({required this.remote});

  @override
  Future<void> initiatePayment(PaymentRequest request, BuildContext context) async {
    try {
      final data = await remote.createCheckout(request);

      // If backend returned a redirect URL, open it
      if (data is Map && data['url'] != null) {
        final url = Uri.parse(data['url'].toString());
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to open payment URL.')));
        }
        return;
      }

      String? clientSecret;
      String? publishableKey;
      if (data is Map) {
        clientSecret = data['clientSecret'] ?? data['client_secret'] ?? (data['paymentIntent'] is Map ? data['paymentIntent']['client_secret'] : null);
        publishableKey = data['publishableKey'] ?? data['publishable_key'];
      }

      if (publishableKey != null && publishableKey.isNotEmpty) {
        Stripe.publishableKey = publishableKey;
        try {
          await Stripe.instance.applySettings();
        } catch (_) {}
      }

      if (clientSecret != null && clientSecret.isNotEmpty) {
        try {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: clientSecret,
              merchantDisplayName: 'Recell Bazar',
              style: ThemeMode.light,
            ),
          );
          await Stripe.instance.presentPaymentSheet();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment completed.')));
        } on StripeException catch (se) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stripe error: ${se.error.localizedMessage}')));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
        }
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking created — no payment UI returned by server.')));
      try {
        await Clipboard.setData(ClipboardData(text: data.toString()));
      } catch (_) {}
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('invalid api key') || msg.contains('stripe')) {
        await _showStripeConfigDialog(context, e.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _showStripeConfigDialog(BuildContext context, String details) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Stripe Configuration Error'),
        content: SingleChildScrollView(
          child: ListBody(children: [
            const Text('Server reported a Stripe configuration issue.'),
            const SizedBox(height: 8),
            Text(details, style: TextStyle(color: Colors.red.shade700)),
            const SizedBox(height: 12),
            const Text('Fix steps:'),
            const Text('1) Ensure your server has STRIPE_SECRET_KEY set to sk_test_...'),
            const Text('2) Optionally set STRIPE_PUBLISHABLE_KEY to pk_test_...'),
            const SizedBox(height: 8),
            const Text('You can copy these example commands to set env vars on your backend machine.'),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final example = "export STRIPE_SECRET_KEY=sk_test_xxx\nexport STRIPE_PUBLISHABLE_KEY=pk_test_xxx";
              await Clipboard.setData(ClipboardData(text: example));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Example env commands copied to clipboard')));
            },
            child: const Text('Copy Example'),
          ),
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }
}
