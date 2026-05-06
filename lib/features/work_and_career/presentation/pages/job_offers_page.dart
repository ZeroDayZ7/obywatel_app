import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/work_and_career/application/job_offers_notifier.dart';

class JobOffersPage extends ConsumerWidget {
  const JobOffersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobOffersProvider);

    return state.when(
      data: (offers) => ListView.builder(
        
        
        itemCount: offers.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(offers[i].title),
          subtitle: Text(offers[i].company),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }
}
