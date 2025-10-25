//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dargon2_flutter_desktop/dargon2_flutter_desktop_plugin.h>
#include <flutter_secure_storage_linux/flutter_secure_storage_linux_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) dargon2_flutter_desktop_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "Dargon2FlutterDesktopPlugin");
  dargon2_flutter_desktop_plugin_register_with_registrar(dargon2_flutter_desktop_registrar);
  g_autoptr(FlPluginRegistrar) flutter_secure_storage_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterSecureStorageLinuxPlugin");
  flutter_secure_storage_linux_plugin_register_with_registrar(flutter_secure_storage_linux_registrar);
}
