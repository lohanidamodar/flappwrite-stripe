import 'dart:convert';

import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';

class CheckoutScreen extends ConsumerWidget {
  CheckoutScreen({Key? key}) : super(key: key);
  final _cardEditController = CardEditController();
  Future<void> _startGooglePay(BuildContext context, double total) async {
    final googlePaySupported = await Stripe.instance
        .isGooglePaySupported(const IsGooglePaySupportedParams());
    if (googlePaySupported) {
      try {
        // 1. fetch Intent Client Secret from backend
        final clientSecret = await fetchClientSecret(context, total);

        // 2.present google pay sheet
        await Stripe.instance.initGooglePay(const GooglePayInitParams(
            testEnv: true,
            merchantName: "Example Merchant Name",
            countryCode: 'us'));

        await Stripe.instance.presentGooglePay(
          PresentGooglePayParams(clientSecret: clientSecret),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Google Pay payment succesfully completed')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Google pay is not supported on this device')),
      );
    }
  }

  _handleCardPay(BuildContext context, WidgetRef ref) async {
    if (!_cardEditController.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Card details not entered completely")));
      return;
    }

    final clientSecret =
        await fetchClientSecret(context, ref.watch(cartTotalProvider));

    final billingDetails = BillingDetails(
      email: context.authNotifier.user!.email,
      phone: '+48888000888',
      address: const Address(
        city: 'Kathmandu',
        country: 'NP',
        line1: 'Chabahil, Kathmandu',
        line2: '',
        state: 'Bagmati',
        postalCode: '44600',
      ),
    );

    try {
      final paymentIntent = await Stripe.instance.confirmPayment(
        clientSecret,
        PaymentMethodParams.card(
          billingDetails: billingDetails,
          setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
        ),
      );
      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        ref.read(cartProvider.notifier).emptyCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Success!: The payment was confirmed successfully!"),
          ),
        );
        Navigator.pop(context);
      }
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.error.localizedMessage ?? e.toString())));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (context.authNotifier.user?.email != null &&
              context.authNotifier.user?.email != '')
            Text(
              context.authNotifier.user!.email,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          const SizedBox(height: 10.0),
          CardField(
            controller: _cardEditController,
          ),
          ListTile(
            title: const Text("Total Amount"),
            trailing: Text(
              '\$${ref.watch(cartTotalProvider).toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _handleCardPay(context, ref),
            child: const Text("Confirm"),
          ),
          if (defaultTargetPlatform == TargetPlatform.android) ...[
            const Text("Or"),
            SizedBox(
              height: 60,
              child: GooglePayButton(
                onTap: () =>
                    _startGooglePay(context, ref.read(cartTotalProvider)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<String> fetchClientSecret(BuildContext context, double total) async {
    final functions = Functions(context.authNotifier.client);
    final execution = await functions.createExecution(
        functionId: 'createPaymentIntent',
        data: jsonEncode({
          'currency': 'usd',
          'amount': (total * 100).toInt(),
        }),
        xasync: false);
    if (execution.stdout.isNotEmpty) {
      final data = jsonDecode(execution.stdout);
      return data['client_secret'];
    }
    return '';
  }
}
