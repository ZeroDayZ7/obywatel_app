import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/documents/data/mock_document_service.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/document_card.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/document_category_header.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/ticket_tile.dart';
import 'package:obywatel_plus/features/documents/presentation/widget/documents_screen/wide_document_card.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  static const double _cardWidth = 160.0;
  static const double _cardHeight = 115.0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      size: ContainerSize.medium,
      appBar: AppAppBar(
        title: 'Dokumenty',
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const DocumentCategoryHeader(title: 'Tożsamość i Obywatelstwo'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: _cardWidth,
                    height: _cardHeight,
                    child: DocumentCard(
                      title: 'Dowód osobisty',
                      icon: Icons.badge,
                      color: Colors.blue,
                      isVerified: true,
                      onTap: () => context.push(
                        '${AppRoutes.documents}/${AppRoutes.idCard}',
                        extra: MockDocumentService.getMockIdCard(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _cardWidth,
                    height: _cardHeight,
                    child: DocumentCard(
                      title: 'Paszport',
                      icon: Icons.public,
                      color: Colors.red.shade900,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          const DocumentCategoryHeader(title: 'Uprawnienia i Praca'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: _cardWidth,
                    height: _cardHeight,
                    child: DocumentCard(
                      title: 'Prawo jazdy',
                      icon: Icons.directions_car,
                      color: Colors.green,
                      status: 'Kat. B, A',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    width: _cardWidth,
                    height: _cardHeight,
                    child: DocumentCard(
                      title: 'Karta Dużej Rodziny',
                      icon: Icons.family_restroom,
                      color: Colors.orange,
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    width: _cardWidth,
                    height: _cardHeight,
                    child: DocumentCard(
                      title: 'Legitymacja emeryta',
                      icon: Icons.elderly,
                      color: Colors.teal,
                      onTap: () {},
                    ),
                  ),
                  SizedBox(
                    width: _cardWidth,
                    height: _cardHeight,
                    child: DocumentCard(
                      title: 'Pozwolenie na broń',
                      icon: Icons.security,
                      color: Colors.blueGrey,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          const DocumentCategoryHeader(title: 'Edukacja'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: WideDocumentCard(
                title: 'Legitymacja studencka',
                subtitle: 'Politechnika Warszawska',
                expiry: 'Ważna do 31.10.2026',
                icon: Icons.school,
                color: Colors.indigo,
                onTap: () => context.push(
                  '${AppRoutes.documents}/${AppRoutes.idCard}',
                  extra: MockDocumentService.getMockStudentCard(),
                ),
              ),
            ),
          ),

          const DocumentCategoryHeader(title: 'Transport i Podróże'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const TicketTile(
                  title: 'Bilet okresowy - ZTM Warszawa',
                  subtitle: '90-dniowy • Strefa 1+2',
                  icon: Icons.directions_bus,
                  color: Colors.red,
                ),
                TicketTile(
                  title: 'Karta lojalnościowa PKP',
                  subtitle: 'Intercity Premium',
                  icon: Icons.train,
                  color: Colors.orange.shade800,
                ),
                TicketTile(
                  title: 'Bilet lotniczy: WAW -> JFK',
                  subtitle: '24 Maj 2026 • LOT Polish Airlines',
                  icon: Icons.flight_takeoff,
                  color: Colors.blue.shade800,
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
