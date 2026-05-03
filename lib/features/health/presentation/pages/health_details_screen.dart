import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/health/application/health_records_provider.dart';
import 'package:obywatel_plus/features/health/domain/models/health_record.dart';

class HealthDetailsScreen extends ConsumerWidget {
  final String type;

  const HealthDetailsScreen({super.key, required this.type});

  // health_details_screen.dart

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordType = HealthRecordType.values.byName(type);
    final recordsAsync = ref.watch(healthRecordsProvider(recordType));

    // Zamiast Scaffold, zwracamy bezpośrednio zawartość,
    // bo AppScaffold jest już we wrapperze.
    return recordsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (err, stack) => Center(child: Text('Błąd: $err')),
      data: (records) {
        if (records.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(record.title),
                subtitle: Text('${record.doctorName ?? ""} • ${record.status}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Brak danych', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
