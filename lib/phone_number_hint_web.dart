// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'phone_number_hint_platform_interface.dart';

/// A web implementation of the PhoneNumberHintPlatform of the PhoneNumberHint plugin.
class PhoneNumberHintWeb extends PhoneNumberHintPlatform {
  /// Constructs a PhoneNumberHintWeb
  PhoneNumberHintWeb();

  static void registerWith(Registrar registrar) {
    PhoneNumberHintPlatform.instance = PhoneNumberHintWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
