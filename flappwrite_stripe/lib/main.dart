import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';
import 'package:flappwrite_stripe/screens/login.dart';
import 'package:flappwrite_stripe/screens/main.dart';
import 'package:flappwrite_stripe/screens/reigster.dart';
import 'package:flutter/material.dart';

final client = Client();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  client
      .setEndpoint('https://demo.appwrite.io/v1')
      .setProject('flutter-stripe');
  runApp(FlAppwriteAccountKit(
    child: const MyApp(),
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Appwrite Stripe Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        routes: {
          "/": (context) => const MainScreen(),
          "login": (context) => const LoginPage(),
          "register": (context) => const RegisterPage(),
        });
  }
}
