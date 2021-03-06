import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = await context.authNotifier.create(
                userId: 'unique()',
                name: _nameController.text,
                email: _emailController.text,
                password: _passwordController.text,
              );
              if (user != null) {
                Navigator.pop(context);
              }
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
