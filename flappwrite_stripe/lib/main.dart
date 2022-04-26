import 'dart:io';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flappwrite_stripe/res/colors.dart';
import 'package:flappwrite_stripe/screens/cart.dart';
import 'package:flappwrite_stripe/screens/checkout.dart';
import 'package:flappwrite_stripe/screens/login.dart';
import 'package:flappwrite_stripe/screens/main.dart';
import 'package:flappwrite_stripe/screens/reigster.dart';
import 'package:flappwrite_stripe/widgets/build_with_appwrite_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/config.dart' as config;

final client = Client();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = config.publishableKey;
  Stripe.merchantIdentifier = 'merchent.flappwrite.test';
  Stripe.urlScheme = 'appwrite-callback-${config.projectId}';
  if (Platform.isAndroid || Platform.isIOS) {
    await Stripe.instance.applySettings();
  }
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 60),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: AppColors.secondaryColor,
          ),
          actionsIconTheme: const IconThemeData(
            color: AppColors.secondaryColor,
          ),
          foregroundColor: const Color.fromRGBO(55, 59, 77, 1),
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: AppColors.titleTextColor,
          ),
        ),
        cardTheme: const CardTheme(
          elevation: 0.5,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme.copyWith(
                displayMedium:
                    ThemeData.light().textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleTextColor,
                        ),
              ),
        ),
      ),
      builder: (context, child) {
        return BuiltWithAppwriteWrapper(
          child: child!,
        );
      },
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
