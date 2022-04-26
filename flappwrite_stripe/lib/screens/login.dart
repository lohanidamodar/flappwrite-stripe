import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              "Welcome back to\nAppwrite Store",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20.0),
            Text(
              "Enter to Your Account",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 20.0),
            const Text("Email"),
            const SizedBox(height: 10.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text("Password"),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                final loggedIn = await context.authNotifier.createSession(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                if (!loggedIn && mounted) {
                  debugPrint(context.authNotifier.error);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text(context.authNotifier.error ?? 'Unknown error')));
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
                child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
