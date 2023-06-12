import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'phone_number_hint_platform_interface.dart';

/// An implementation of [PhoneNumberHintPlatform] that uses method channels.
class MethodChannelPhoneNumberHint extends PhoneNumberHintPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('phone_number_hint');

  @override
  Future<String?> requestHint(
      ) async {
    final result = await methodChannel.invokeMethod<String>('requestHint');
    return result;
  }
}
