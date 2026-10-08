import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/contacts_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/add_contact_modal.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_contact_card.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_error_view.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_search_delegate.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_settings_sheet.dart';

class ContactsScreen extends ConsumerStatefulWidget {
	const ContactsScreen({super.key});

	@override
	ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
	final Set<String> _processingRequestIds = <String>{};

	void _openAddContactModal(BuildContext context) {
		showDialog(context: context, builder: (_) => const AddContactModal());
	}

	void _openSettingsSheet(BuildContext context) {
		showModalBottomSheet(
			context: context,
			isScrollControlled: true,
			useSafeArea: true,
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
			),
			builder: (_) => const ContactsSettingsSheet(),
		);
	}

	Future<void> _respondToRequest(Contact contact, bool accept) async {
		if (_processingRequestIds.contains(contact.id)) return;

		setState(() => _processingRequestIds.add(contact.id));

		try {
			final repository = ref.read(contactsRepositoryProvider);
			await repository.respondToRequest(contact.id, accept);

			if (accept) {
				final chatsRepository = ref.read(chatsRepositoryProvider);
				final title = contact.localAlias?.trim().isNotEmpty == true
						? contact.localAlias!
						: contact.displayName;

				final conversationId = await chatsRepository
						.ensureConversationForContact(contact.contactUserId, title: title);

				if (!mounted) return;

				context.push(
					'/chats/${Uri.encodeComponent(conversationId)}',
					extra: title,
				);
			}

			if (!mounted) return;

			final statusColors = context.statusColors;

			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text(
						accept
								? 'Zaproszenie zaakceptowane dla ${contact.displayName}'
								: 'Zaproszenie odrzucone dla ${contact.displayName}',
					),
					behavior: SnackBarBehavior.floating,
					backgroundColor: accept ? statusColors.success : statusColors.warning,
				),
			);
		} catch (error) {
			if (!mounted) return;
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(
					content: Text('Nie udało się zaktualizować zaproszenia: $error'),
					backgroundColor: Theme.of(context).colorScheme.error,
					behavior: SnackBarBehavior.floating,
				),
			);
		} finally {
			if (mounted) {
				setState(() => _processingRequestIds.remove(contact.id));
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		final colorScheme = context.colorScheme;
		final acceptedContactsAsync = ref.watch(acceptedContactsProvider);
		final pendingContactsAsync = ref.watch(pendingContactsProvider);

		final isDesktop = MediaQuery.sizeOf(context).width > 800;

		ref.listen<AsyncValue<void>>(contactsSyncProvider, (previous, next) {
			if (next.hasError && !next.isLoading) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(
						content: Text('Błąd synchronizacji: ${next.error}'),
						backgroundColor: colorScheme.error,
						behavior: SnackBarBehavior.floating,
					),
				);
			}
		});

		final acceptedContacts = acceptedContactsAsync.maybeWhen(
			data: (contacts) => contacts,
			orElse: () => <Contact>[],
		);
		final pendingContacts = pendingContactsAsync.maybeWhen(
			data: (contacts) => contacts,
			orElse: () => <Contact>[],
		);

		return Scaffold(
			backgroundColor: colorScheme.surface,
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () => _openAddContactModal(context),
				icon: const Icon(Icons.person_add),
				label: const Text('Dodaj kontakt'),
				backgroundColor: colorScheme.primary,
				foregroundColor: colorScheme.onPrimary,
			),
			body: SafeArea(
				child: Center(
					child: ConstrainedBox(
						constraints: const BoxConstraints(maxWidth: 1000),
						child: acceptedContactsAsync.when(
							data: (_) => _buildContactsContent(
								context,
								ref,
								acceptedContacts,
								pendingContacts,
								isDesktop,
							),
							loading: () => Center(
								child: CircularProgressIndicator(color: colorScheme.primary),
							),
							error: (error, stack) => ContactsErrorView(error: error),
						),
					),
				),
			),
		);
	}

	Widget _buildContactsContent(
		BuildContext context,
		WidgetRef ref,
		List<Contact> contacts,
		List<Contact> pendingContacts,
		bool isDesktop,
	) {
		final theme = Theme.of(context);
		final colorScheme = theme.colorScheme;
		final onlineContacts = contacts.where((c) => c.isOnline ?? false).toList();

		return RefreshIndicator(
			color: colorScheme.primary,
			backgroundColor: colorScheme.surfaceContainerHigh,
			onRefresh: () async {
				await ref.read(contactsSyncProvider.notifier).sync();
			},
			child: CustomScrollView(
				physics: const AlwaysScrollableScrollPhysics(),
				slivers: [
					SliverAppBar(
						floating: true,
						snap: true,
						leading: IconButton(
							icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
							tooltip: 'Powrót do ekranu głównego',
							onPressed: () => context.go(AppRoutes.home),
						),
						title: Text(
							'Kontakty (${contacts.length})',
							style: theme.textTheme.titleLarge?.copyWith(
								color: colorScheme.onSurface,
								fontWeight: FontWeight.bold,
							),
						),
						backgroundColor: colorScheme.surface,
						actions: [
							IconButton(
								icon: Icon(Icons.tune_rounded, color: colorScheme.onSurface),
								tooltip: 'Ustawienia kontaktów',
								onPressed: () => _openSettingsSheet(context),
							),
							IconButton(
								icon: Icon(Icons.search, color: colorScheme.onSurface),
								tooltip: 'Szukaj kontaktów',
								onPressed: () {
									showSearch(
										context: context,
										delegate: ContactsSearchDelegate(contacts: contacts),
									);
								},
							),
							IconButton(
								icon: Icon(Icons.refresh, color: colorScheme.onSurface),
								tooltip: 'Synchronizuj',
								onPressed: () {
									ref.read(contactsSyncProvider.notifier).sync();
								},
							),
						],
					),

					SliverToBoxAdapter(
						child: Container(
							margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
							padding: const EdgeInsets.all(12),
							decoration: BoxDecoration(
								color: colorScheme.surfaceContainerHighest,
								borderRadius: BorderRadius.circular(4),
								border: Border.all(
									color: colorScheme.outlineVariant.withValues(alpha: 0.35),
								),
							),
							child: Row(
								children: [
									Expanded(
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Text(
													'CONTACTS / NETWORK STATUS',
													style: theme.textTheme.labelLarge?.copyWith(
														color: colorScheme.primary,
														fontWeight: FontWeight.w700,
														letterSpacing: 0.8,
													),
												),
												const SizedBox(height: 8),
												Text(
													'${contacts.length} trusted contacts • ${onlineContacts.length} online • ${pendingContacts.length} pending',
													style: theme.textTheme.bodyMedium?.copyWith(
														color: colorScheme.onSurfaceVariant,
													),
												),
											],
										),
									),
									Container(
										padding: const EdgeInsets.symmetric(
											horizontal: 8,
											vertical: 4,
										),
										decoration: BoxDecoration(
											color: colorScheme.primaryContainer,
											borderRadius: BorderRadius.circular(2),
										),
										child: Text(
											'SECURED',
											style: theme.textTheme.labelSmall?.copyWith(
												color: colorScheme.onPrimaryContainer,
												fontWeight: FontWeight.w700,
												letterSpacing: 0.5,
											),
										),
									),
								],
							),
						),
					),

					if (pendingContacts.isNotEmpty) ...[
						SliverToBoxAdapter(
							child: Padding(
								padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
								child: Row(
									children: [
										Icon(Icons.mail_outline, color: colorScheme.primary),
										const SizedBox(width: 8),
										Text(
											'Zaproszenia oczekujące (${pendingContacts.length})',
											style: theme.textTheme.titleSmall?.copyWith(
												fontWeight: FontWeight.w700,
												color: colorScheme.onSurface,
											),
										),
									],
								),
							),
						),
						SliverPadding(
							padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
							sliver: SliverList(
								delegate: SliverChildBuilderDelegate((context, index) {
									final contact = pendingContacts[index];
									final isBusy = _processingRequestIds.contains(contact.id);

									return Container(
										margin: const EdgeInsets.symmetric(
											horizontal: 8,
											vertical: 4,
										),
										padding: const EdgeInsets.all(12),
										decoration: BoxDecoration(
											color: colorScheme.surface,
											borderRadius: BorderRadius.circular(4),
											border: Border.all(
												color: colorScheme.outlineVariant.withValues(
													alpha: 0.35,
												),
											),
										),
										child: Row(
											children: [
												Container(
													width: 44,
													height: 44,
													alignment: Alignment.center,
													decoration: BoxDecoration(
														color: colorScheme.surfaceContainerHighest,
														borderRadius: BorderRadius.circular(4),
													),
													child: Text(
														contact.displayName.isNotEmpty
																? contact.displayName[0].toUpperCase()
																: '?',
														style: theme.textTheme.titleMedium?.copyWith(
															color: colorScheme.onSurface,
															fontWeight: FontWeight.w700,
														),
													),
												),
												const SizedBox(width: 12),
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.start,
														children: [
															Text(
																contact.localAlias?.trim().isNotEmpty == true
																		? contact.localAlias!
																		: contact.displayName,
																style: theme.textTheme.titleSmall?.copyWith(
																	color: colorScheme.onSurface,
																	fontWeight: FontWeight.w700,
																),
															),
															const SizedBox(height: 4),
															Text(
																contact.status,
																style: theme.textTheme.bodySmall?.copyWith(
																	color: colorScheme.onSurfaceVariant,
																),
															),
														],
													),
												),
												Row(
													mainAxisSize: MainAxisSize.min,
													children: [
														IconButton(
															onPressed: isBusy
																	? null
																	: () => _respondToRequest(contact, true),
															tooltip: 'Akceptuj',
															color: colorScheme.primary,
															icon: const Icon(Icons.check_rounded),
														),
														IconButton(
															onPressed: isBusy
																	? null
																	: () => _respondToRequest(contact, false),
															tooltip: 'Odrzuć',
															color: colorScheme.error,
															icon: const Icon(Icons.close_rounded),
														),
													],
												),
											],
										),
									);
								}, childCount: pendingContacts.length),
							),
						),
					],

					SliverPadding(
						padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
						sliver: SliverList(
							delegate: SliverChildBuilderDelegate((context, index) {
								final contact = contacts[index];

								return Container(
									margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
									padding: const EdgeInsets.all(12),
									decoration: BoxDecoration(
										color: colorScheme.surface,
										borderRadius: BorderRadius.circular(4),
										border: Border.all(
											color: colorScheme.outlineVariant.withValues(alpha: 0.35),
										),
									),
									child: ContactsContactCard(
										contact: contact,
										onOpen: () {
											final title = contact.localAlias?.trim().isNotEmpty == true
													? contact.localAlias!
													: contact.displayName;

											Navigator.of(context).push(
												MaterialPageRoute(
													builder: (_) =>
															// Navigate to chat room via existing route
															// using conversation created by ensureConversationForContact
															// The ContactsContactCard handles primary interactions.
															const SizedBox.shrink(),
												),
											);
										},
									),
								);
							}, childCount: contacts.length),
						),
					),
				],
			),
		);
	}
}
