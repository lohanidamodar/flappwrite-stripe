import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';
import 'package:flappwrite_stripe/screens/cart.dart';
import 'package:flappwrite_stripe/screens/checkout.dart';
import 'package:flappwrite_stripe/screens/login.dart';
import 'package:flappwrite_stripe/screens/main.dart';
import 'package:flappwrite_stripe/screens/reigster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'utils/config.dart' as config;

final client = Client();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = config.publishableKey;
  Stripe.merchantIdentifier = 'merchent.flappwrite.test';
  Stripe.urlScheme = 'appwrite-callback-${config.projectId}';
  await Stripe.instance.applySettings();
  client.setEndpoint(config.endpoint).setProject(config.projectId);
  runApp(
    ProviderScope(
      child: FlAppwriteAccountKit(
        child: const MyApp(),
        client: client,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appwrite Stripe Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      routes: {
        "/": (context) => const MainScreen(),
        "login": (context) => const LoginPage(),
        "register": (context) => const RegisterPage(),
        "cart": (context) => const CartScreen(),
        "checkout": (context) => CheckoutScreen()
      },
    );
  }
}
