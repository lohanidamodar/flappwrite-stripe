import 'dart:convert';

import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';

class CheckoutScreen extends ConsumerWidget {
  CheckoutScreen({Key? key}) : super(key: key);
  final _cardEditController = CardEditController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          CardField(
            controller: _cardEditController,
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_cardEditController.complete) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Card details not entered completely")));
                return;
              }

              final clientSecret = await fetchClientSecret(
                  context, ref.watch(cartTotalProvider));

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
                      content: Text(
                          "Success!: The payment was confirmed successfully!"),
                    ),
                  );
                  Navigator.pop(context);
                }
              } on StripeException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.error.localizedMessage ?? e.toString())));
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Future<String> fetchClientSecret(BuildContext context, double total) async {
    final functions = Functions(context.authNotifier.client);
    final execution = await functions.createExecution(
        functionId: 'createPaymentIntent',
        data: jsonEncode({
          'email': context.authNotifier.user!.email,
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
