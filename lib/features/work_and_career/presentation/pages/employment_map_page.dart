import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';

class EmploymentMapPage extends StatelessWidget {
  const EmploymentMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(title: 'Mapa zatrudnienia'),
      child: const Center(child: Text('Employment Map Page')),
    );
  }
}
