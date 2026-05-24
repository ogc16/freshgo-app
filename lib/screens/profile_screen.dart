import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/ui.dart';
import '../widgets/language_picker.dart';

class MenuItem {
  final String icon;
  final String label;
  final String sub;
  final Color bg;
  final String? action;
  const MenuItem({required this.icon, required this.label, required this.sub, required this.bg, this.action});
}

List<MenuItem> _menuItems(String locale) => [
  MenuItem(icon: '\u{1F464}', label: tr('profile.editProfile', locale), sub: tr('profile.editProfileSub', locale), bg: green3),
  MenuItem(icon: '\u{1F4CD}', label: tr('profile.savedAddresses', locale), sub: tr('profile.savedAddressesSub', locale), bg: const Color(0xFFE3F2FD)),
  MenuItem(icon: '\u{1F4B3}', label: tr('profile.paymentMethods', locale), sub: tr('profile.paymentMethodsSub', locale), bg: const Color(0xFFFFF3D6)),
  MenuItem(icon: '\u{1F4E6}', label: tr('profile.orderHistory', locale), sub: tr('profile.orderHistorySub', locale), bg: const Color(0xFFF3E5F5), action: 'orders'),
  MenuItem(icon: '\u{1F3C6}', label: 'Loyalty Program', sub: 'Earn points & view receipts', bg: const Color(0xFFFFF8E1), action: 'loyalty'),
  MenuItem(icon: '\u{1F381}', label: tr('profile.offers', locale), sub: tr('profile.offersSub', locale), bg: const Color(0xFFFCE4EC)),
  MenuItem(icon: '\u{1F514}', label: tr('profile.notifications', locale), sub: tr('profile.notificationsSub', locale), bg: const Color(0xFFFFF3E0)),
  MenuItem(icon: '\u{1F4AC}', label: tr('profile.help', locale), sub: tr('profile.helpSub', locale), bg: green3),
  MenuItem(icon: '\u{2B50}', label: tr('profile.rate', locale), sub: tr('profile.rateSub', locale), bg: const Color(0xFFFFFDE7)),
];

class ProfileScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.onNavigate, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  late TextEditingController _nameCtl;
  late TextEditingController _emailCtl;
  late TextEditingController _phoneCtl;
  late TextEditingController _addressCtl;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProfileProvider>();
    _nameCtl = TextEditingController(text: p.name);
    _emailCtl = TextEditingController(text: p.email);
    _phoneCtl = TextEditingController(text: p.phone);
    _addressCtl = TextEditingController(text: p.address);
    p.loadFromSupabase().then((_) {
      if (mounted) {
        _nameCtl.text = p.name;
        _emailCtl.text = p.email;
        _phoneCtl.text = p.phone;
        _addressCtl.text = p.address;
      }
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    _addressCtl.dispose();
    super.dispose();
  }

  void _save() {
    context.read<ProfileProvider>().updateAll(
      name: _nameCtl.text,
      email: _emailCtl.text,
      phone: _phoneCtl.text,
      address: _addressCtl.text,
    );
    context.read<ProfileProvider>().saveToSupabase();
    setState(() => _editing = false);
  }

  void _cancel() {
    final p = context.read<ProfileProvider>();
    _nameCtl.text = p.name;
    _emailCtl.text = p.email;
    _phoneCtl.text = p.phone;
    _addressCtl.text = p.address;
    setState(() => _editing = false);
  }

  Future<bool> _confirmLogout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(tr('profile.cancel', context.read<LocaleProvider>().locale))),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: danger),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final profile = context.watch<ProfileProvider>();
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
                  GestureDetector(
                    onTap: _editing ? null : () => setState(() => _editing = true),
                    child: Container(
                      width: 76, height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
                      ),
                      child: Center(
                        child: _editing
                          ? const Icon(Icons.camera_alt, color: Colors.white, size: 28)
                          : const Text('\u{1F464}', style: TextStyle(fontSize: 34)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!_editing) ...[
                    Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(profile.phone, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                    const SizedBox(height: 3),
                    Text(profile.email, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                  ] else
                    const SizedBox(height: 4),
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
            child: _editing ? _buildEditForm(locale, profile) : _buildMenu(locale, menu),
          ),
        ),
        BottomNav(active: 'profile', onNavigate: widget.onNavigate),
      ],
    );
  }

  Widget _buildEditForm(String locale, ProfileProvider profile) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        _buildField(tr('profile.nameHint', locale), _nameCtl, Icons.person),
        const SizedBox(height: 14),
        _buildField(tr('profile.phoneHint', locale), _phoneCtl, Icons.phone),
        const SizedBox(height: 14),
        _buildField(tr('profile.emailHint', locale), _emailCtl, Icons.email),
        const SizedBox(height: 14),
        _buildField(tr('profile.addressHint', locale), _addressCtl, Icons.location_on),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: txt3,
                  side: const BorderSide(color: Color(0xFFE0D9D2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(tr('profile.cancel', locale), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: profile.saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: profile.saving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(tr('profile.save', locale), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController ctl, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E2DC)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: ctl,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          icon: Icon(icon, size: 20, color: green),
          border: InputBorder.none,
          hintText: label,
          hintStyle: const TextStyle(color: txt3),
        ),
      ),
    );
  }

  Widget _buildMenu(String locale, List<MenuItem> menu) {
    return ListView(
      children: [
        GestureDetector(
          onTap: () => setState(() => _editing = true),
          child: _menuRow(menu[0], locale),
        ),
        ...menu.skip(1).map((item) => GestureDetector(
          onTap: item.action != null ? () => widget.onNavigate(item.action!) : null,
          child: _menuRow(item, locale),
        )),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFFF5F2EE)),
        const SizedBox(height: 16),
        LanguagePicker(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              if (await _confirmLogout()) widget.onLogout();
            },
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
    );
  }

  Widget _menuRow(MenuItem item, String locale) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F2EE), width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(item.icon, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 1),
                Text(item.sub, style: const TextStyle(fontSize: 12, color: txt3)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: txt3),
        ],
      ),
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
