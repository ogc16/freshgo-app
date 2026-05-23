import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../widgets/language_picker.dart';
import '../widgets/ui.dart';

class LoginScreen extends StatefulWidget {
  final ValueChanged<String> onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 52, bottom: 40, left: 24, right: 24),
            decoration: const BoxDecoration(color: green),
            child: Stack(
              children: [
                Positioned(top: -40, right: -40, child: Container(width: 160, height: 160, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x0FFFFFFF)))),
                Positioned(bottom: -30, left: -30, child: Container(width: 120, height: 120, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x26F5A100)))),
                Column(
                  children: [
                    const Text('\u{1F6D2}', style: TextStyle(fontSize: 62)),
                    const SizedBox(height: 14),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                        children: [
                          const TextSpan(text: 'Fresh'),
                          const TextSpan(text: 'Go', style: TextStyle(color: amber)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${tr('app.tagline', locale)}\n${tr('app.subtitle', locale)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr('login.phoneNumber', locale).toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                FormInput(
                  hintText: tr('login.phoneHint', locale),
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  prefix: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(radButton), color: Colors.white),
                    child: const Text('\u{1F1FA}\u{1F1EC} +256', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: tr('login.continueSms', locale),
                  onPressed: () => widget.onLogin(_phoneController.text),
                ),
                _Divider(label: tr('login.orContinueWith', locale)),
                _SocialButton(icon: 'G', label: tr('login.continueGoogle', locale), bg: Colors.white, border: const Color(0xFFE0DCD6), onTap: () => widget.onLogin('demo')),
                const SizedBox(height: 10),
                _SocialButton(icon: '\u{1F49B}', label: tr('login.continueMtn', locale), bg: const Color(0xFFFFF7E0), border: const Color(0xFFFBC02D), onTap: () => widget.onLogin('demo')),
                const SizedBox(height: 10),
                _SocialButton(icon: '\u{2764}\u{FE0F}', label: tr('login.continueAirtel', locale), bg: const Color(0xFFFFF0F0), border: const Color(0xFFEF5350), onTap: () => widget.onLogin('demo')),
                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    text: '${tr('login.terms', locale)} ',
                    style: const TextStyle(fontSize: 12, color: txt3),
                    children: [
                      TextSpan(text: tr('login.termsService', locale), style: const TextStyle(color: green, fontWeight: FontWeight.w600)),
                      const TextSpan(text: ' & '),
                      TextSpan(text: tr('login.privacyPolicy', locale), style: const TextStyle(color: green, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                LanguagePicker(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFE8E4DE), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: const TextStyle(fontSize: 13, color: txt3)),
          ),
          const Expanded(child: Divider(color: Color(0xFFE8E4DE), thickness: 1)),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final Color bg;
  final Color border;
  final VoidCallback onTap;
  const _SocialButton({required this.icon, required this.label, required this.bg, required this.border, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          side: BorderSide(color: border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radButton)),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: txt)),
          ],
        ),
      ),
    );
  }
}
