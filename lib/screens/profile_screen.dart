import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../widgets/ui.dart';
import '../widgets/language_picker.dart';

List<Map<String, dynamic>> _menuItems(String locale) => [
  {'icon': '\u{1F464}', 'label': tr('profile.editProfile', locale), 'sub': tr('profile.editProfileSub', locale), 'bg': green3},
  {'icon': '\u{1F4CD}', 'label': tr('profile.savedAddresses', locale), 'sub': tr('profile.savedAddressesSub', locale), 'bg': const Color(0xFFE3F2FD)},
  {'icon': '\u{1F4B3}', 'label': tr('profile.paymentMethods', locale), 'sub': tr('profile.paymentMethodsSub', locale), 'bg': const Color(0xFFFFF3D6)},
  {'icon': '\u{1F4E6}', 'label': tr('profile.orderHistory', locale), 'sub': tr('profile.orderHistorySub', locale), 'bg': const Color(0xFFF3E5F5), 'action': 'orders'},
  {'icon': '\u{1F381}', 'label': tr('profile.offers', locale), 'sub': tr('profile.offersSub', locale), 'bg': const Color(0xFFFCE4EC)},
  {'icon': '\u{1F514}', 'label': tr('profile.notifications', locale), 'sub': tr('profile.notificationsSub', locale), 'bg': const Color(0xFFFFF3E0)},
  {'icon': '\u{1F4AC}', 'label': tr('profile.help', locale), 'sub': tr('profile.helpSub', locale), 'bg': green3},
  {'icon': '\u{2B50}', 'label': tr('profile.rate', locale), 'sub': tr('profile.rateSub', locale), 'bg': const Color(0xFFFFFDE7)},
];

class ProfileScreen extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.onNavigate, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final menu = _menuItems(locale);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          decoration: const BoxDecoration(color: green),
          child: Stack(
            children: [
              Positioned(top: -30, right: -30, child: Container(width: 130, height: 130,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x0DFFFFFF)))),
              Column(
                children: [
                  Container(
                    width: 76, height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.18),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
                    ),
                    child: const Center(child: Text('\u{1F464}', style: TextStyle(fontSize: 34))),
                  ),
                  const SizedBox(height: 12),
                  Text(tr('profile.name', locale), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(tr('profile.phone', locale), style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Stat(label: tr('profile.orders', locale), value: '12'),
                      const SizedBox(width: 24),
                      _Stat(label: tr('profile.addresses', locale), value: '3'),
                      const SizedBox(width: 24),
                      _Stat(label: tr('profile.rating', locale), value: '4.8'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              children: [
                ...menu.map((item) => GestureDetector(
                  onTap: item.containsKey('action') ? () => onNavigate(item['action'] as String) : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFF5F2EE), width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: item['bg'] as Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(item['icon'] as String, style: const TextStyle(fontSize: 18))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['label'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 1),
                              Text(item['sub'] as String, style: const TextStyle(fontSize: 12, color: txt3)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 16, color: txt3),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF5F2EE)),
                const SizedBox(height: 16),
                LanguagePicker(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onLogout,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE2E2),
                      foregroundColor: danger,
                      side: const BorderSide(color: Color(0xFFFFCDD2), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(tr('profile.logOut', locale), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomNav(active: 'profile', onNavigate: onNavigate),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: amber, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
      ],
    );
  }
}
