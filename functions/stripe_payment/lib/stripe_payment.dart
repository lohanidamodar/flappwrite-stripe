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
  final prefs = user.prefs.data;
  String? customerId = prefs['stripeCustomerId'];

  var stripe = Stripe(request.env['STRIPE_SECRET_KEY']);

  // create account for customer if it doesn't already exist
  dynamic customer;
  if (customerId == null) {
    customer =
        await stripe.core.customers.create(params: {"email": user.email});
    customerId = customer!['id'];
    if (customerId == null) {
      throw (customer.toString());
    } else {
      prefs['stripeCustomerId'] = customerId;
      await account.updatePrefs(prefs: prefs);
    }
  }
  final data = jsonDecode(request.env['APPWRITE_FUNCTION_DATA']);
  final paymentIntent = await stripe.core.paymentIntents!.create(params: {
    "amount": data['amount'],
    "currency": data['currency'],
    "customer": customerId,
  });
  response.json({
    "paymentIntent": paymentIntent,
    "client_secret": paymentIntent!['client_secret'],
  });
}
