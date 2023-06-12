import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'phone_number_hint_method_channel.dart';

abstract class PhoneNumberHintPlatform extends PlatformInterface {
  /// Constructs a PhoneNumberHintPlatform.
  PhoneNumberHintPlatform() : super(token: _token);

  static final Object _token = Object();

  static PhoneNumberHintPlatform _instance = MethodChannelPhoneNumberHint();

  /// The default instance of [PhoneNumberHintPlatform] to use.
  ///
  /// Defaults to [MethodChannelPhoneNumberHint].
  static PhoneNumberHintPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PhoneNumberHintPlatform] when
  /// they register themselves.
  static set instance(PhoneNumberHintPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> requestHint() {
    throw UnimplementedError('request hint has not been implemented.');
  }
}
