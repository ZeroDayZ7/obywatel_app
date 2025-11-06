// lib/core/storage/shared_preferences_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    FutureProvider<SharedPreferencesService>((ref) async {
      final prefs = await SharedPreferences.getInstance();
      return SharedPreferencesService(prefs);
    });
