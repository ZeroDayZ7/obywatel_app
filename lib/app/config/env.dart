import 'constants_dev.dart' if (dart.vm.product) 'constants_prod.dart';

const bool isProduction = bool.fromEnvironment(
  'dart.vm.product',
  defaultValue: false,
);

// import 'constants_dev.dart'
// import 'constants_prod.dart'

final bool serverOnline = true;

const apiConstants = ApiConstants();
