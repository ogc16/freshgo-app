import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/ui.dart';

class LoginScreen extends StatefulWidget {
  final ValueChanged<String> onLogin;
  final VoidCallback onSignUp;
  final VoidCallback onGuestLogin;
  final ValueChanged<String> onPhoneLogin;
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onSignUp,
    required this.onGuestLogin,
    required this.onPhoneLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isEmailMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final auth = context.watch<AuthProvider>();
    final loading = auth.status == AuthStatus.authenticating;
    final error = auth.error;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
            decoration: const BoxDecoration(color: green),
            child: Stack(
              children: [
                Positioned(top: -40, right: -40, child: Container(width: 160, height: 160, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x0FFFFFFF)))),
                Positioned(bottom: -30, left: -30, child: Container(width: 120, height: 120, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x26F5A100)))),
                Column(
                  children: [
                    const Text('\u{1F37D}\u{FE0F}', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 14),
                    const Text('FoodApp', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(
                      tr('login.tagline', locale),
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
                _buildTabToggle(locale),
                const SizedBox(height: 24),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFCDD2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: danger, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(error, style: const TextStyle(fontSize: 13, color: danger))),
                          GestureDetector(onTap: () => context.read<AuthProvider>().clearError(), child: const Icon(Icons.close, size: 16, color: danger)),
                        ],
                      ),
                    ),
                  ),
                if (_isEmailMode) ..._buildEmailFields(locale, loading),
                if (!_isEmailMode) ..._buildPhoneFields(locale, loading),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: loading ? null : widget.onGuestLogin,
                    child: Text(
                      tr('login.continueAsGuest', locale),
                      style: const TextStyle(fontSize: 14, color: txt2, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${tr('login.noAccount', locale)} ', style: const TextStyle(fontSize: 14, color: txt2)),
                    GestureDetector(
                      onTap: loading ? null : widget.onSignUp,
                      child: Text(tr('login.signUp', locale), style: const TextStyle(fontSize: 14, color: green, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle(String locale) {
    return Container(
      decoration: BoxDecoration(
        color: green3,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _tabItem(tr('login.email', locale), true),
          _tabItem(tr('login.phoneNumber', locale), false),
        ],
      ),
    );
  }

  Widget _tabItem(String label, bool isEmail) {
    final active = isEmail == _isEmailMode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isEmailMode = isEmail),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: active ? green : txt3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmailFields(String locale, bool loading) {
    return [
      Text(tr('login.email', locale).toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
      const SizedBox(height: 6),
      FormInput(
        hintText: tr('login.emailHint', locale),
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        enabled: !loading,
      ),
      const SizedBox(height: 16),
      Text(tr('login.password', locale).toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
      const SizedBox(height: 6),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _passwordController,
              enabled: !loading,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: tr('login.passwordHint', locale),
                hintStyle: const TextStyle(color: txt3, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radButton),
                  borderSide: const BorderSide(color: border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radButton),
                  borderSide: const BorderSide(color: border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radButton),
                  borderSide: const BorderSide(color: green, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontSize: 15, color: txt),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: green3,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: green, size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: _rememberMe ? green : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _rememberMe ? green : border, width: 1.5),
                  ),
                  child: _rememberMe
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 8),
                Text(tr('login.rememberMe', locale), style: const TextStyle(fontSize: 13, color: txt2)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(tr('login.forgotPassword', locale), style: const TextStyle(fontSize: 13, color: green, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      const SizedBox(height: 20),
      PrimaryButton(
        text: tr('login.signIn', locale),
        loading: loading,
        onPressed: loading ? null : () => widget.onLogin(_emailController.text),
      ),
    ];
  }

  List<Widget> _buildPhoneFields(String locale, bool loading) {
    return [
      Text(tr('login.phoneNumber', locale).toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
      const SizedBox(height: 6),
      FormInput(
        hintText: tr('login.phoneHint', locale),
        keyboardType: TextInputType.phone,
        controller: _phoneController,
        enabled: !loading,
        prefix: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: green3,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('+256', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: green)),
        ),
      ),
      const SizedBox(height: 20),
      PrimaryButton(
        text: tr('login.continueSms', locale),
        loading: loading,
        onPressed: loading ? null : () => widget.onPhoneLogin(_phoneController.text),
      ),
    ];
  }
}
