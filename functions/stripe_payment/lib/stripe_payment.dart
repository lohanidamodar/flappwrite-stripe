import 'package:stripedart/stripedart.dart';

Future<void> start(final request, final response) async {
  response.json(request.env);
  // var stripe = Stripe(request.env['STRIPE_SECRET_KEY']);

  // final customer = await stripe.core.customers
  //     .create(params: {"email": request.env['email']});
  // print(customer);
  // final paymentIntent = await stripe.core.paymentIntents!.create(params: {
  //   "amount": 100,
  //   "currency": "USD",
  //   "customer": customer!['id'],
  // });
  // print(paymentIntent);
  // response.json({
  //   "client_secret": paymentIntent!['client_secret'],
  // });
}
