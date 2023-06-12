import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phone_number_hint/phone_number_hint_method_channel.dart';

void main() {
  MethodChannelPhoneNumberHint platform = MethodChannelPhoneNumberHint();
  const MethodChannel channel = MethodChannel('phone_number_hint');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
