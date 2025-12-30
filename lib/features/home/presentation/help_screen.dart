import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/settings_card.dart';

class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'from': 'AxoAI', 'message': 'Cześć! Jak mogę Ci pomóc?'},
  ];

  void _sendMessage() {
    if (_chatController.text.isEmpty) return;
    setState(() {
      _messages.add({'from': 'You', 'message': _chatController.text});
      _messages.add({
        'from': 'AxoAI',
        'message': 'Tutaj jest link do ofert pracy: https://example.com/jobs',
      });
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.help_title.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =====================
          // AXO AI CHAT
          // =====================
          Text(
            LocaleKeys.help_axoai_section.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['from'] == 'You';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.blueAccent
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            msg['message']!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.help_axoai_input_hint.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      labelKey: LocaleKeys.help_axoai_send.tr(),
                      onPressed: _sendMessage,
                      variant: AppButtonVariant.primary,
                      fullWidth: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // =====================
          // CONTACT SUPPORT
          // =====================
          Text(
            LocaleKeys.help_contact_section.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SettingsCard(
            icon: Icons.email,
            title: 'support@yourapp.com',
            subtitle: LocaleKeys.help_contact_email.tr(),
            showArrow: false,
            onTap: () {},
          ),
          SettingsCard(
            icon: Icons.phone,
            title: '+48 123 456 789',
            subtitle: LocaleKeys.help_contact_phone.tr(),
            showArrow: false,
            onTap: () {},
          ),
          SettingsCard(
            icon: Icons.chat,
            title: LocaleKeys.help_contact_chat.tr(),
            subtitle: LocaleKeys.help_contact_chat_subtitle.tr(),
            showArrow: false,
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // =====================
          // FAQ / QUICK LINKS
          // =====================
          Text(
            LocaleKeys.help_faq_section.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton(
                labelKey: 'How to reset password?',
                onPressed: () {},
                variant: AppButtonVariant.secondary,
                fullWidth: false,
              ),
              AppButton(
                labelKey: 'How to set up PIN?',
                onPressed: () {},
                variant: AppButtonVariant.secondary,
                fullWidth: false,
              ),
              AppButton(
                labelKey: 'Contact HR department',
                onPressed: () {},
                variant: AppButtonVariant.secondary,
                fullWidth: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
