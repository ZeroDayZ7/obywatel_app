import 'dart:io';

class AppStoreLinks {
  static String get updateUrl {
    if (Platform.isAndroid) {
      return 'https://play.google.com/store/apps/details?id=com.obywatel.app';
    } else if (Platform.isIOS) {
      return 'https://apps.apple.com/app/idXXXXXXXXX';
    }
    return '';
  }
}
