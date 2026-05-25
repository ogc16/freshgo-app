import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/contact_sheet.dart';
import '../widgets/ui.dart';
import '../widgets/language_picker.dart';

class _MenuItemData {
  final IconData icon;
  final String label;
  final String sub;
  final Color bg;
  final Color iconColor;
  final String action;
  const _MenuItemData({required this.icon, required this.label, required this.sub, required this.bg, required this.iconColor, required this.action});
}

List<_MenuItemData> _accountMenu(String locale) => [
  _MenuItemData(icon: Icons.person_outline, label: tr('profile.editProfile', locale), sub: tr('profile.editProfileSub', locale), bg: green3, iconColor: green, action: 'edit'),
  _MenuItemData(icon: Icons.location_on_outlined, label: tr('profile.savedAddresses', locale), sub: tr('profile.savedAddressesSub', locale), bg: const Color(0xFFE3F2FD), iconColor: info, action: 'addresses'),
];

List<_MenuItemData> _paymentMenu(String locale) => [
  _MenuItemData(icon: Icons.payment_outlined, label: tr('profile.paymentMethods', locale), sub: tr('profile.paymentMethodsSub', locale), bg: const Color(0xFFFFF3D6), iconColor: const Color(0xFFE6A800), action: 'payment'),
  _MenuItemData(icon: Icons.local_offer_outlined, label: tr('profile.offers', locale), sub: tr('profile.offersSub', locale), bg: const Color(0xFFFCE4EC), iconColor: danger, action: 'offers'),
];

List<_MenuItemData> _historyMenu(String locale) => [
  _MenuItemData(icon: Icons.receipt_long_outlined, label: tr('profile.orderHistory', locale), sub: tr('profile.orderHistorySub', locale), bg: const Color(0xFFF3E5F5), iconColor: const Color(0xFF7B1FA2), action: 'orders'),
  _MenuItemData(icon: Icons.workspace_premium_outlined, label: 'Loyalty Program', sub: 'Earn points & view receipts', bg: const Color(0xFFFFF8E1), iconColor: amber, action: 'loyalty'),
];

List<_MenuItemData> _supportMenu(String locale) => [
  _MenuItemData(icon: Icons.notifications_outlined, label: tr('profile.notifications', locale), sub: tr('profile.notificationsSub', locale), bg: const Color(0xFFFFF3E0), iconColor: const Color(0xFFE65100), action: 'notifications'),
  _MenuItemData(icon: Icons.help_outline, label: tr('profile.help', locale), sub: tr('profile.helpSub', locale), bg: green3, iconColor: green, action: 'help'),
  _MenuItemData(icon: Icons.star_outline, label: tr('profile.rate', locale), sub: tr('profile.rateSub', locale), bg: const Color(0xFFFFFDE7), iconColor: amber, action: 'rate'),
];

class ProfileScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.onNavigate, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool _editing = false;
  late TextEditingController _nameCtl;
  late TextEditingController _emailCtl;
  late TextEditingController _phoneCtl;
  late TextEditingController _addressCtl;
  late AnimationController _slideCtl;
  late Animation<Offset> _slideAnim;

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
    _slideCtl = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(CurvedAnimation(parent: _slideCtl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    _addressCtl.dispose();
    _slideCtl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _editing = !_editing);
    if (_editing) _slideCtl.forward(); else _slideCtl.reverse();
  }

  void _save() {
    context.read<ProfileProvider>().updateAll(
      name: _nameCtl.text,
      email: _emailCtl.text,
      phone: _phoneCtl.text,
      address: _addressCtl.text,
    );
    context.read<ProfileProvider>().saveToSupabase();
    _toggleEdit();
  }

  void _cancel() {
    final p = context.read<ProfileProvider>();
    _nameCtl.text = p.name;
    _emailCtl.text = p.email;
    _phoneCtl.text = p.phone;
    _addressCtl.text = p.address;
    _toggleEdit();
  }

  Future<bool> _confirmLogout() async {
    final locale = context.read<LocaleProvider>().locale;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(tr('profile.cancel', locale))),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (mounted) {
      context.read<ProfileProvider>().uploadAvatar(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final profile = context.watch<ProfileProvider>();
    return Column(
      children: [
        _buildHeader(locale, profile),
        Expanded(child: _editing ? _buildEditBody(locale, profile) : _buildMenuBody(locale)),
        BottomNav(active: 'profile', onNavigate: widget.onNavigate),
      ],
    );
  }

  Widget _buildHeader(String locale, ProfileProvider profile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C5C35), Color(0xFF2E7D4F)],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _editing ? _pickImage : () => _toggleEdit(),
                child: Stack(
                  children: [
                    Container(
                      width: 68, height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2.5),
                      ),
                      child: ClipOval(
                        child: profile.avatarUrl.isNotEmpty
                            ? Image.network(profile.avatarUrl, fit: BoxFit.cover, width: 68, height: 68)
                            : const Icon(Icons.person, size: 34, color: Colors.white70),
                      ),
                    ),
                    if (_editing)
                      Positioned(right: 0, bottom: 0,
                        child: Container(
                          width: 24, height: 24,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: amber),
                          child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name.isNotEmpty ? profile.name : 'Guest User',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    if (profile.phone.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.phone, size: 12, color: Colors.white.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(profile.phone, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                        ],
                      ),
                    if (profile.email.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.email_outlined, size: 12, color: Colors.white.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(profile.email, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(rad),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(icon: Icons.receipt_outlined, label: tr('profile.orders', locale), value: '12'),
                _divider(),
                _Stat(icon: Icons.location_on_outlined, label: tr('profile.addresses', locale), value: '3'),
                _divider(),
                _Stat(icon: Icons.star_half, label: tr('profile.rating', locale), value: '4.8'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 28, color: Colors.white.withValues(alpha: 0.15));

  Widget _buildMenuBody(String locale) {
    return Container(
      decoration: const BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
        children: [
          _buildSection(locale, Icons.manage_accounts_outlined, 'Account', _accountMenu(locale)),
          const SizedBox(height: 8),
          _buildSection(locale, Icons.credit_card_outlined, 'Payments & Offers', _paymentMenu(locale)),
          const SizedBox(height: 8),
          _buildSection(locale, Icons.history_outlined, 'Orders & Rewards', _historyMenu(locale)),
          const SizedBox(height: 8),
          _buildSection(locale, Icons.support_outlined, 'Support & Feedback', _supportMenu(locale)),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE8E4DF)),
          const SizedBox(height: 12),
          LanguagePicker(),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                if (await _confirmLogout()) widget.onLogout();
              },
              icon: const Icon(Icons.logout, size: 18),
              label: Text(tr('profile.logOut', locale)),
              style: OutlinedButton.styleFrom(
                foregroundColor: danger,
                side: const BorderSide(color: Color(0xFFFFCDD2), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String locale, IconData sectionIcon, String title, List<_MenuItemData> items) {
    return SectionCard(
      title: title,
      child: Column(
        children: items.map((item) => _menuRow(item)).toList(),
      ),
    );
  }

  Widget _menuRow(_MenuItemData item) {
    return InkWell(
      onTap: () => _handleMenuAction(item.action),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(item.icon, size: 18, color: item.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
                  const SizedBox(height: 1),
                  Text(item.sub, style: const TextStyle(fontSize: 12, color: txt3)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: txt3.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildEditBody(String locale, ProfileProvider profile) {
    return Container(
      decoration: const BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _cancel,
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: border),
                    color: Colors.white,
                  ),
                  child: const Icon(Icons.close, size: 18, color: txt3),
                ),
              ),
              const SizedBox(width: 12),
              const Text('Edit Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              profile.saving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: green))
                  : GestureDetector(
                      onTap: _save,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 24),
          FormInput(
            hintText: tr('profile.nameHint', locale),
            controller: _nameCtl,
            prefix: const Icon(Icons.person_outline, size: 20, color: green),
          ),
          const SizedBox(height: 14),
          FormInput(
            hintText: tr('profile.phoneHint', locale),
            controller: _phoneCtl,
            keyboardType: TextInputType.phone,
            prefix: const Icon(Icons.phone_outlined, size: 20, color: green),
          ),
          const SizedBox(height: 14),
          FormInput(
            hintText: tr('profile.emailHint', locale),
            controller: _emailCtl,
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(Icons.email_outlined, size: 20, color: green),
          ),
          const SizedBox(height: 14),
          FormInput(
            hintText: tr('profile.addressHint', locale),
            controller: _addressCtl,
            prefix: const Icon(Icons.location_on_outlined, size: 20, color: green),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlineButton(
                  text: tr('profile.cancel', locale),
                  onPressed: _cancel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: tr('profile.save', locale),
                  onPressed: profile.saving ? null : _save,
                  disabled: profile.saving,
                  loading: profile.saving,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'edit':
        _toggleEdit();
        break;
      case 'orders':
      case 'loyalty':
        widget.onNavigate(action);
        break;
      case 'help':
        showContactSheet(context);
        break;
      case 'addresses':
      case 'payment':
      case 'offers':
      case 'notifications':
      case 'rate':
        final all = [..._accountMenu(''), ..._paymentMenu(''), ..._historyMenu(''), ..._supportMenu('')];
        showComingSoon(context, all.firstWhere((m) => m.action == action).label);
        break;
    }
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _Stat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: amber),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800, height: 1)),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11, height: 1)),
      ],
    );
  }
}
