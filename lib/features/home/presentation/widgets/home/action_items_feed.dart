import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/border_radius.dart';
import 'package:obywatel_plus/features/home/domain/model/action_item.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/home/action_item_card.dart';

class ActionItemsFeed extends StatefulWidget {
  const ActionItemsFeed({super.key});

  @override
  State<ActionItemsFeed> createState() => _ActionItemsFeedState();
}

class _ActionItemsFeedState extends State<ActionItemsFeed> {
  int _visibleCount = 3; // Domyślnie wyświetlamy 3 na start
  ActionScope? _selectedScope; // null = Wszystkie, inaczej Local/Global

  // Mockowa baza 10 spraw (AI + Lokalne głosowania + Sprawy sądowe)
  final List<ActionItem> _mockItems = [
    ActionItem(
      id: '1',
      title: 'Wypadek drogowy – Łukasz Żak',
      description:
          'Analiza materiału dowodowego i rekonstrukcja przebiegu zdarzenia przygotowana przez AI.',
      scope: ActionScope.global,
      type: ActionType.courtCase,
      aiOutcomePrediction:
          'Rekomendowany wymiar kary: do 20 lat pozbawienia wolności.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ActionItem(
      id: '2',
      title: 'Głosowanie: Nowa ławka i zieleń na ul. Stawowej',
      description:
          'Budżet obywatelski 2026. Zdecyduj o rewitalizacji skweru miejskiego.',
      scope: ActionScope.local,
      type: ActionType.voting,
      locationName: 'Sosnowiec, Centrum',
      imageUrl:
          'https://images.unsplash.com/photo-1519331379826-f10be5486c6f?q=80&w=400',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ActionItem(
      id: '3',
      title: 'Procedury bezpieczeństwa i działania Policji',
      description:
          'Projekt nowelizacji ustawy o uprawnieniach służb mundurowych.',
      scope: ActionScope.global,
      type: ActionType.aiSummary,
      aiOutcomePrediction:
          'AI Raport: Zmiana dotyczy 4 kluczowych artykułów prawnych.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ActionItem(
      id: '4',
      title: 'Remont torowiska tramwajowego',
      description:
          'Konsultacje społeczne dotyczące tymczasowej organizacji ruchu.',
      scope: ActionScope.local,
      type: ActionType.announcement,
      locationName: 'Katowice, Załęże',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ActionItem(
      id: '5',
      title: 'Cyfryzacja rejestrów cywilnych',
      description:
          'Wdrożenie modułu automatycznego poświadczania podpisów cyfrowych.',
      scope: ActionScope.global,
      type: ActionType.aiSummary,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ActionItem(
      id: '6',
      title: 'Budowa wybiegu dla psów w Parku Śląskim',
      description: 'Głosowanie nad przydziałem środków z funduszu lokalnego.',
      scope: ActionScope.local,
      type: ActionType.voting,
      locationName: 'Chorzów',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ActionItem(
      id: '7',
      title: 'Proces apelacyjny w sprawie cyfrowej tożsamości',
      description:
          'AI przeanalizowało 120 stron uzasadnienia wyroku pierwszej instancji.',
      scope: ActionScope.global,
      type: ActionType.courtCase,
      aiOutcomePrediction: 'AI: 85% szans na utrzymanie wyroku w mocy.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ActionItem(
      id: '8',
      title: 'Oświetlenie LED na przejściach dla pieszych',
      description: 'Zgłoszenie mieszkańca zatwierdzone do realizacji.',
      scope: ActionScope.local,
      type: ActionType.announcement,
      locationName: 'Gliwice',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ActionItem(
      id: '9',
      title: 'Krajowy system powiadamiania kryzysowego',
      description: 'Testy wydajnościowe infrastruktury regionalnej.',
      scope: ActionScope.global,
      type: ActionType.announcement,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ActionItem(
      id: '10',
      title: 'Nasadzenia drzew przy ul. Mikołowskiej',
      description: 'Wybór gatunków drzew odpornych na zanieczyszczenia.',
      scope: ActionScope.local,
      type: ActionType.voting,
      locationName: 'Katowice',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filtrowanie po zasięgu (Lokalne / Globalne)
    final filteredItems = _mockItems.where((item) {
      if (_selectedScope == null) return true;
      return item.scope == _selectedScope;
    }).toList();

    final displayedItems = filteredItems.take(_visibleCount).toList();
    final hasMore = _visibleCount < filteredItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nagłówek i Filtry
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sprawy na dzisiaj',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: AppRadius.radiusLg,
              ),
              child: Text(
                'Aktywny Obywatel',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Segments Filter (Wszystkie / Lokalne / Globalne)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(theme, label: 'Wszystkie', scope: null),
              const SizedBox(width: 8),
              _buildFilterChip(
                theme,
                label: '📍 Lokalne',
                scope: ActionScope.local,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                theme,
                label: '🌐 Globalne',
                scope: ActionScope.global,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Lista Spraw
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedItems.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return ActionItemCard(item: displayedItems[index]);
          },
        ),

        const SizedBox(height: 12),

        // Pasek przycisków ładujących więcej (+1 / +5 / +10)
        if (hasMore)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Pokaż kolejne:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _buildLoadMoreButton(context, amount: 1),
                const SizedBox(width: 6),
                _buildLoadMoreButton(context, amount: 5),
                const SizedBox(width: 6),
                _buildLoadMoreButton(context, amount: 10),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip(
    ThemeData theme, {
    required String label,
    required ActionScope? scope,
  }) {
    final isSelected = _selectedScope == scope;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedScope = scope;
          _visibleCount = 3; // Reset limitu po zmianie filtra
        });
      },
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.textTheme.bodyMedium?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context, {required int amount}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          _visibleCount += amount;
        });
      },
      borderRadius: AppRadius.radiusLg,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: AppRadius.radiusLg,
        ),
        child: Text(
          '+$amount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
