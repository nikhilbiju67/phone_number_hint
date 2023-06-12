#include "include/phone_number_hint/phone_number_hint_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "phone_number_hint_plugin.h"

void PhoneNumberHintPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  phone_number_hint::PhoneNumberHintPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
