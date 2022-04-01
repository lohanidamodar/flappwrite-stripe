import 'dart:convert';

import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:dart_appwrite/models.dart';
import 'package:stripedart/stripedart.dart';

final client = appwrite.Client();
final account = appwrite.Account(client);

Future<User> getUser() async {
  return await account.get();
}

Future<void> start(final request, final response) async {
  if (request.env['STRIPE_SECRET_KEY'] == null ||
      request.env['STRIPE_PUBLISHABLE_KEY'] == null) {
    return response.send('Stripe payment keys are missing', 400);
  }

  if (request.env['APPWRITE_ENDPOINT'] == null) {
    return response.send('Appwrite endpoint is missing', 400);
  }

  // final userId = request.env['APPWRITE_FUNCTION_USER_ID'];
  final jwt = request.env['APPWRITE_FUNCTION_JWT'];

  client
      .setEndpoint(request.env['APPWRITE_ENDPOINT'])
      .setProject(request.env['APPWRITE_FUNCTION_PROJECT_ID'])
      .setJWT(jwt);

  final user = await getUser();

  final data = jsonDecode(request.env['APPWRITE_FUNCTION_DATA']);
  var stripe = Stripe(request.env['STRIPE_SECRET_KEY']);

  final customer = await stripe.core.customers
      .create(params: {"email": user.email});
  print(customer);
  final paymentIntent = await stripe.core.paymentIntents!.create(params: {
    "amount": data['amount'],
    "currency": data['currency'],
    "customer": customer!['id'],
  });
  response.json({
    "client_secret": paymentIntent!['client_secret'],
  });
}
