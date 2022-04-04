import 'dart:convert';

import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';

class CheckoutScreen extends ConsumerWidget {
  CheckoutScreen({Key? key}) : super(key: key);
  final _emailController = TextEditingController();
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
          TextFormField(
            controller: _emailController,
          ),
          const SizedBox(height: 10.0),
          CardField(
            controller: _cardEditController,
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_cardEditController.complete) {
                return;
              }

              final clientSecret = await fetchClientSecret(
                  context, ref.watch(cartTotalProvider));

              final billingDetails = BillingDetails(
                email: _emailController.text,
                phone: '+48888000888',
                address: const Address(
                  city: 'Kathmandu',
                  country: 'Nepal',
                  line1: 'Chabahil, Kathmandu',
                  line2: '',
                  state: 'Bagmati',
                  postalCode: '44600',
                ),
              );

              final paymentIntent = await Stripe.instance.confirmPayment(
                clientSecret,
                PaymentMethodParams.card(
                  billingDetails: billingDetails,
                  setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text("Success!: The payment was confirmed successfully!"),
                ),
              );
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
          'email': _emailController.text,
          'currency': 'usd',
          'amount': total,
          'request_three_d_secure': 'any'
        }),
        xasync: true);
    return execution.stdout;
  }
}
