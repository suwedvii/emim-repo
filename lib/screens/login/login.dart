import 'package:emim/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final form = GlobalKey<FormState>();

  String? enteredEmail;
  String? enteredPassword;

  void _login() {
    if (form.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const TabsScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.onBackground,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: form,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/msg_logo.png',
                  width: 100,
                ),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Enter your credentials',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('E-Mail Address'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                value.trim().length < 5 ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Password'),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                value.trim().length < 5 ||
                                value.trim().isEmpty) {
                              return 'Enter a valid password with more than 5 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  '(C) Malawi School of Government',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.background,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
