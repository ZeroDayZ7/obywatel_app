import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class JobOffersScreen extends StatelessWidget {
  const JobOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final jobOffers = [
      {
        'title': 'Flutter Developer',
        'company': 'Tech Solutions',
        'location': 'Warsaw',
        'salary': '15 000 - 20 000 PLN',
        'type': 'Full-time',
      },
      {
        'title': 'Backend Engineer',
        'company': 'Innovatech',
        'location': 'Krakow',
        'salary': '18 000 - 25 000 PLN',
        'type': 'Full-time',
      },
      {
        'title': 'UI/UX Designer',
        'company': 'DesignHub',
        'location': 'Remote',
        'salary': '12 000 - 18 000 PLN',
        'type': 'Contract',
      },
      {
        'title': 'Project Manager',
        'company': 'Global Corp',
        'location': 'Gdansk',
        'salary': '16 000 - 22 000 PLN',
        'type': 'Full-time',
      },
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Text(
          LocaleKeys.workAndCareer_job_offers.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: jobOffers.length,
        itemBuilder: (context, index) {
          final offer = jobOffers[index];
          return _JobOfferCard(offer: offer, colorScheme: colorScheme);
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomActionButton(
                  icon: Icons.search_rounded,
                  label: 'Szukaj',
                  colorScheme: colorScheme,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackBar('Szukaj kliknięte', colorScheme),
                    );
                  },
                ),
                _BottomActionButton(
                  icon: Icons.tune_rounded,
                  label: 'Filtruj',
                  colorScheme: colorScheme,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackBar('Filtruj kliknięte', colorScheme),
                    );
                  },
                ),
                _BottomActionButton(
                  icon: Icons.swap_vert_rounded,
                  label: 'Sortuj',
                  colorScheme: colorScheme,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackBar('Sortuj kliknięte', colorScheme),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SnackBar _buildSnackBar(String message, ColorScheme colorScheme) {
    return SnackBar(
      content: Text(message),
      backgroundColor: colorScheme.primaryContainer,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    );
  }
}

class _JobOfferCard extends StatelessWidget {
  final Map<String, String> offer;
  final ColorScheme colorScheme;

  const _JobOfferCard({required this.offer, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Wybrano: ${offer['title']}'),
                backgroundColor: colorScheme.primaryContainer,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business_rounded,
                        color: colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            offer['company']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: Icons.location_on_outlined,
                      label: offer['location']!,
                      colorScheme: colorScheme,
                    ),
                    _InfoChip(
                      icon: Icons.payments_outlined,
                      label: offer['salary']!,
                      colorScheme: colorScheme,
                    ),
                    _InfoChip(
                      icon: Icons.work_outline_rounded,
                      label: offer['type']!,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _BottomActionButton({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
