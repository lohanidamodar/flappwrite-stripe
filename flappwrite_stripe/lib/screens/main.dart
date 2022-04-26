import 'package:flappwrite_stripe/screens/login.dart';
import 'package:flappwrite_stripe/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

import 'home.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (context.authNotifier.status) {
      case AuthStatus.uninitialized:
        return const SplashPage();
      case AuthStatus.authenticated:
        return const HomePage();
      case AuthStatus.authenticating:
      case AuthStatus.unauthenticated:
        return const LoginPage();
    }
  }
}
