# phone_number_hint

phone_number_hint is a Flutter package that provides a simple way to retrieve phone number hints from the user's device.It uses  Phone Number Hint API

The Phone Number Hint API, a library powered by Google Play services, provides a frictionless way to show a user’s (SIM-based) phone numbers as a hint.

The benefits to using Phone Number Hint include the following:

- No additional permission requests are needed
- Eliminates the need for the user to manually type in the phone number
- No Google account is needed
- Not directly tied to sign in/up workflows
- Wider support for Android versions compared to Autofill

## Features

- Phone number hint functionality: Retrieves phone number hints from the user's device.
- Easy integration: Simple API to request and display phone number hints.
## DEMO
![Phone Number Hint Demo](https://i.ibb.co/gPKNNyk/Whats-App-Video-2023-06-12-at-21-04-24-Adobe-Express-1.gif)

## Getting Started

### Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  phone_number_hint: ^1.0.0
```

Then, run flutter pub get to install the package.

```Dart
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


