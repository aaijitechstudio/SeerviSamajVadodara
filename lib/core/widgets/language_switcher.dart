import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    // Get current language name
    String getCurrentLanguageName() {
      switch (currentLocale.languageCode) {
        case 'hi':
          return l10n.hindi;
        case 'gu':
          return l10n.gujarati;
        case 'en':
        default:
          return l10n.english;
      }
    }

    return PopupMenuButton<Locale>(
      tooltip: l10n.selectLanguage,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 20),
            const SizedBox(width: 6),
            Text(
              getCurrentLanguageName(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
      onSelected: (Locale locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: const Locale('hi', 'IN'),
          child: Row(
            children: [
              if (currentLocale.languageCode == 'hi')
                const Icon(Icons.check, size: 20),
              const SizedBox(width: 8),
              Text(l10n.hindi),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('en', 'US'),
          child: Row(
            children: [
              if (currentLocale.languageCode == 'en')
                const Icon(Icons.check, size: 20),
              const SizedBox(width: 8),
              Text(l10n.english),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('gu', 'IN'),
          child: Row(
            children: [
              if (currentLocale.languageCode == 'gu')
                const Icon(Icons.check, size: 20),
              const SizedBox(width: 8),
              Text(l10n.gujarati),
            ],
          ),
        ),
      ],
    );
  }
}
