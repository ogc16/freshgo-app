import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/ui.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SignUpScreen({super.key, required this.onBack});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  bool get _valid =>
    _nameCtl.text.trim().isNotEmpty &&
    _emailCtl.text.contains('@') &&
    _passwordCtl.text.length >= 6 &&
    _passwordCtl.text == _confirmCtl.text;

  Future<void> _submit() async {
    if (!_valid) return;
    final auth = context.read<AuthProvider>();
    final err = await auth.signUpWithEmail(_emailCtl.text.trim(), _passwordCtl.text);
    if (err == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created! Check your email to confirm.'), backgroundColor: green),
      );
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final loading = auth.status == AuthStatus.authenticating;
    final error = auth.error;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            decoration: const BoxDecoration(color: green),
            child: Column(
              children: [
                Row(
                  children: [
                    AppBackButton(onPressed: widget.onBack),
                    const SizedBox(width: 12),
                    Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('\u{1F4CB}', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text(
                  'Join FreshGo today!',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
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
                          GestureDetector(onTap: () => auth.clearError(), child: const Icon(Icons.close, size: 16, color: danger)),
                        ],
                      ),
                    ),
                  ),
                Text('FULL NAME', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                FormInput(hintText: 'Namukasa Sarah', controller: _nameCtl, enabled: !loading, onChanged: (_) => setState(() {})),
                const SizedBox(height: 16),
                Text('EMAIL ADDRESS', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                FormInput(hintText: 'sarah@example.com', keyboardType: TextInputType.emailAddress, controller: _emailCtl, enabled: !loading, onChanged: (_) => setState(() {})),
                const SizedBox(height: 16),
                Text('PASSWORD (min 6 chars)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                _passwordField(_passwordCtl, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword), loading),
                const SizedBox(height: 16),
                Text('CONFIRM PASSWORD', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: txt2, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                _passwordField(_confirmCtl, _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm), loading),
                if (_confirmCtl.text.isNotEmpty && _passwordCtl.text != _confirmCtl.text)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text('Passwords do not match', style: TextStyle(fontSize: 11, color: danger.withValues(alpha: 0.8))),
                  ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Create Account',
                  loading: loading,
                  onPressed: loading ? null : _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(TextEditingController ctl, bool obscure, VoidCallback toggle, bool loading) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ctl,
            enabled: !loading,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: 'Enter password',
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
          onTap: toggle,
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: green3, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: green, size: 20)),
          ),
        ),
      ],
    );
  }
}
