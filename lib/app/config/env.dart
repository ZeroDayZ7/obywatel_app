// import 'constants_dev.dart' if (dart.vm.product) 'constants_prod.dart';
import 'package:flutter/foundation.dart';
// import 'constants_prod.dart';
import 'constants_dev.dart';
const apiConstants = ApiConstants();

final bool isProduction = true;

void debugPrintEnv() {
  if (kDebugMode) {
    debugPrint('🧩 Loaded API base URL: ${apiConstants.baseUrl}');
  }
}
