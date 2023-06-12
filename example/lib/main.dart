import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:phone_number_hint/phone_number_hint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Unknown';
  final _phoneNumberHintPlugin = PhoneNumberHint();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getPhoneNumber() async {
    String? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      result = await _phoneNumberHintPlugin.requestHint(
              ) ??
          '';
      _controller.text = result;
    } on PlatformException {
      result = 'Failed to get hint.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(
        onFocus: () {
          getPhoneNumber();
        },
        controller: _controller,
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  Function onFocus;
  TextEditingController controller;

  LoginScreen({required this.onFocus, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your phone number',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Focus(
              onFocusChange: (focus) {
                if (focus) {
                  onFocus();
                }
              },
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                onFocus();
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
