import 'dart:io';
import 'dart:async';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/config/update_links.dart';
import 'package:obywatel_plus/app/bootstrap/force_update_provider.dart';

class ForceUpdateScreen extends ConsumerWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.system_update_alt,
                size: 96,
                color: Colors.orangeAccent,
              ),
              const SizedBox(height: 32),
              Text(
                LocaleKeys.force_update_screen_title.tr(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                tr(
                  LocaleKeys.force_update_screen_description,
                  namedArgs: {'appName': 'Obywatel App'},
                ),
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                icon: const Icon(Icons.system_update_alt),
                label: Text(LocaleKeys.force_update_screen_update_button.tr()),
                onPressed: () => _handleUpdate(ref),
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.force_update_screen_mandatory_info.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpdate(WidgetRef ref) async {
    final forceUpdate = ref.read(forceUpdateProvider);

    if (Platform.isWindows && forceUpdate.windowsUrl.isNotEmpty) {
      // Pobieramy plik Windows z backendu
      await _updateAppWindows(forceUpdate.windowsUrl);
    } else {
      // Android/iOS używa AppStoreLinks
      final url = Platform.isAndroid || Platform.isIOS
          ? AppStoreLinks.updateUrl
          : forceUpdate.windowsUrl;

      if (url.isNotEmpty) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _updateAppWindows(String downloadUrl) async {
    if (downloadUrl.isEmpty) return;

    // Zapisz w tymczasowej lokalizacji
    final savePath = '${Directory.systemTemp.path}/app_update.exe';

    final dio = Dio();
    await dio.download(
      downloadUrl,
      savePath,
      onReceiveProgress: (received, total) {
        final progress = ((received / total) * 100).toStringAsFixed(0);
        debugPrint('Download progress: $progress%');
      },
    );

    // Uruchom instalator
    await io.Process.start(savePath, []);
    io.exit(0); // Zamknij aktualną aplikację
  }
}
