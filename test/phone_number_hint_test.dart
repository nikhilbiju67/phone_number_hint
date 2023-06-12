import 'package:flutter_test/flutter_test.dart';
import 'package:phone_number_hint/phone_number_hint.dart';
import 'package:phone_number_hint/phone_number_hint_platform_interface.dart';
import 'package:phone_number_hint/phone_number_hint_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPhoneNumberHintPlatform
    with MockPlatformInterfaceMixin
    implements PhoneNumberHintPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PhoneNumberHintPlatform initialPlatform = PhoneNumberHintPlatform.instance;

  test('$MethodChannelPhoneNumberHint is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPhoneNumberHint>());
  });

  test('getPlatformVersion', () async {
    PhoneNumberHint phoneNumberHintPlugin = PhoneNumberHint();
    MockPhoneNumberHintPlatform fakePlatform = MockPhoneNumberHintPlatform();
    PhoneNumberHintPlatform.instance = fakePlatform;

    expect(await phoneNumberHintPlugin.getPlatformVersion(), '42');
  });
}
