import 'constants_dev.dart' if (dart.vm.product) 'constants_prod.dart';

const bool isProduction = bool.fromEnvironment(
  'dart.vm.product',
  defaultValue: false,
);
final bool serverOnline = true;

const apiConstants = ApiConstants();
