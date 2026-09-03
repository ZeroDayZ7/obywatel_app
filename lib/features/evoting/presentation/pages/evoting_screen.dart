// lib/features/evoting/presentation/pages/evoting_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';

class EVotingScreen extends StatefulWidget {
  const EVotingScreen({super.key});

  @override
  State<EVotingScreen> createState() => _EVotingScreenState();
}

class _EVotingScreenState extends State<EVotingScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Wszystkie',
    'Lokalne (Twoja okolica)',
    'Regionalne',
    'Krajowe',
    'Moje delegacje',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Powrót do Home',
            onPressed: () => context.go(AppRoutes.home),
          ),
          title: Text(
            'e-Voting Plus',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune_rounded),
              tooltip: 'Filtry',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.how_to_reg_rounded),
              tooltip: 'Deleguj głos',
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sekcja statusu / statystyk użytkownika
            _buildUserVotingStatsCard(theme, colorScheme),
            const SizedBox(height: 20),

            // 2. Kategoria / Filtry horyzontalne
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    onSelected: (_) =>
                        setState(() => _selectedCategoryIndex = index),
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 3. Nagłówek: Pilne / Aktywne
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trwające głosowania',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Zobacz wszystkie',
                    style: TextStyle(color: colorScheme.primary, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 4. Glówne karty głosowań
            _buildVotingCard(
              theme: theme,
              colorScheme: colorScheme,
              tag: 'LOKALNE • Twoja Dzielnica',
              tagColor: colorScheme.primary,
              title:
                  'Budowa ścieżki rowerowej oraz parku kieszonkowego przy ul. Lipowej',
              timeLeft: 'Pozostało: 2 dni',
              participantsCount: '1,420 głosów',
              isUrgent: true,
              voted: false,
            ),
            const SizedBox(height: 12),

            _buildVotingCard(
              theme: theme,
              colorScheme: colorScheme,
              tag: 'KRAJOWE • Ustawa',
              tagColor: colorScheme.secondary,
              title:
                  'Projekt ustawy o cyfryzacji lokalnych procedur administracyjnych',
              timeLeft: 'Pozostało: 5 dni',
              participantsCount: '48,190 głosów',
              isUrgent: false,
              voted: true,
            ),
            const SizedBox(height: 12),

            _buildVotingCard(
              theme: theme,
              colorScheme: colorScheme,
              tag: 'REGIONALNE • Śląskie',
              tagColor: colorScheme.tertiary,
              title:
                  'Alokacja środków z Budżetu Obywatelskiego na rozwój transportu publicznego',
              timeLeft: 'Pozostało: 12 godz.',
              participantsCount: '8,930 głosów',
              isUrgent: true,
              voted: false,
            ),
            const SizedBox(height: 24),

            // 5. Sekcja Płynnej Demokracji (Delegowanie głosów)
            _buildLiquidDemocracyBanner(theme, colorScheme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Wymiarowy kafel statystyk na samej górze
  Widget _buildUserVotingStatsCard(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Twój status: Aktywny wyborca',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Siła Twojego głosu: 1.0x',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Brak aktywnych delegacji na Ciebie',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '12',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  'Oddane głosy',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Karta pojedynczego głosowania
  Widget _buildVotingCard({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String tag,
    required Color tagColor,
    required String title,
    required String timeLeft,
    required String participantsCount,
    required bool isUrgent,
    required bool voted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUrgent
              ? colorScheme.error.withValues(alpha: 0.5)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isUrgent ? 1.5 : 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tagi i status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: tagColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: tagColor,
                          ),
                        ),
                      ),
                      if (voted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 12,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Zagłosowano',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tytuł uchwały/głosowania
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stopka z danymi
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: isUrgent
                            ? colorScheme.error
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeLeft,
                        style: TextStyle(
                          fontSize: 12,
                          color: isUrgent
                              ? colorScheme.error
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: isUrgent
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.how_to_vote_outlined,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        participantsCount,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Baner zachęcający do płynnej demokracji
  Widget _buildLiquidDemocracyBanner(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.15),
            colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.alt_route_rounded,
              color: colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nie masz czasu głosować?',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Przekaż swój głos ekspertowi lub zaufanemu sąsiadowi.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
