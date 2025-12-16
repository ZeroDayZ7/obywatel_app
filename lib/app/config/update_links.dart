import 'dart:io';

class AppStoreLinks {
  static String get updateUrl {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=com.obywatel.app';
    } else if (Platform.isIOS) {
      return 'https://apps.apple.com/app/idXXXXXXXXX';
    } else if (Platform.isWindows) {
      return 'https://yourdomain.com/downloads/yourapp.exe';
    } else if (Platform.isLinux) {
      return 'https://yourdomain.com/downloads/yourapp.AppImage';
    } else if (Platform.isMacOS) {
      return 'https://yourdomain.com/downloads/yourapp.dmg';
    }
    return '';
  }
}
