import 'phone_number_hint_platform_interface.dart';

class PhoneNumberHint {
  Future<String?> requestHint() async {
    return PhoneNumberHintPlatform.instance.requestHint(
    );
  }
}
