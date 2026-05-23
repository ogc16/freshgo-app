import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../i18n/strings.dart';
import 'ui.dart';

class LanguagePicker extends StatelessWidget {
  final bool compact;
  const LanguagePicker({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final localeProv = context.watch<LocaleProvider>();
    final locale = localeProv.locale;

    if (compact) {
      return PopupMenuButton<String>(
        onSelected: (l) => localeProv.setLocale(l),
        initialValue: locale,
        itemBuilder: (_) => LocaleProvider.availableLocales.map((l) =>
          PopupMenuItem(value: l, child: Text(tr('lang.$l', locale))),
        ).toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(radButton),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.translate, size: 16, color: txt2),
              const SizedBox(width: 6),
              Text(tr('lang.$locale', locale), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: txt)),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, size: 16, color: txt2),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(tr('language', locale), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: LocaleProvider.availableLocales.map((l) {
            final active = l == locale;
            return GestureDetector(
              onTap: () => localeProv.setLocale(l),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: active ? green : Colors.white,
                  borderRadius: BorderRadius.circular(radButton),
                  border: Border.all(color: active ? green : border, width: 1.5),
                ),
                child: Text(
                  tr('lang.$l', locale),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : txt,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
