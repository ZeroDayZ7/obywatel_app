import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';

class GovernmentSupportPage extends StatelessWidget {
  const GovernmentSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(title: 'Wsparcie rządowe'),
      child: const Center(child: Text('Government Support Page')),
    );
  }
}
