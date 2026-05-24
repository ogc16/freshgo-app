import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../widgets/ui.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final ValueChanged<String> onVerify;
  final VoidCallback onBack;
  const OtpScreen({super.key, required this.phone, required this.onVerify, required this.onBack});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  int _timer = 30;
  Timer? _countdown;

  @override
  void initState() {
    super.initState();
    _focusNodes[0].requestFocus();
    _startTimer();
  }

  @override
  void dispose() {
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    _countdown?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdown?.cancel();
    setState(() => _timer = 30);
    _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timer <= 1) { t.cancel(); setState(() => _timer = 0); return; }
      setState(() => _timer--);
    });
  }

  void _onDigitChange(int i, String val) {
    if (val.isNotEmpty && i < 3) _focusNodes[i + 1].requestFocus();
  }

  bool get _filled => _controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              AppBackButton(onPressed: widget.onBack),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr('otp.verifyPhone', locale), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text('${tr('otp.codeSent', locale)} +256 ${widget.phone.isEmpty ? '7XX XXX XXX' : widget.phone}',
                      style: const TextStyle(fontSize: 12, color: txt3)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text('\u{1F4F1}', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(tr('otp.enterOtp', locale), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(tr('otp.description', locale),
                    style: const TextStyle(fontSize: 14, color: txt2)),
                const SizedBox(height: 28),
                Row(
                  children: List.generate(4, (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: txt),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: _controllers[i].text.isNotEmpty ? green3 : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: _controllers[i].text.isNotEmpty ? green : border, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: _controllers[i].text.isNotEmpty ? green : border, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: green, width: 2),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) => _onDigitChange(i, v),
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: tr('otp.verifyContinue', locale),
                  onPressed: _filled ? () => widget.onVerify(_controllers.map((c) => c.text).join()) : null,
                  disabled: !_filled,
                ),
                const SizedBox(height: 20),
                _timer > 0
                    ? Text.rich(
                        TextSpan(
                          text: '${tr('otp.notReceived', locale)} ',
                          style: const TextStyle(fontSize: 13, color: txt3),
                          children: [
                            TextSpan(
                              text: '0:${_timer.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: green, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: _startTimer,
                        child: Text(tr('otp.resend', locale),
                            style: const TextStyle(fontSize: 13, color: green, fontWeight: FontWeight.w600)),
                      ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: green3, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Text('\u{1F4A1}', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(tr('otp.demoHint', locale),
                            style: const TextStyle(fontSize: 12, color: txt2)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
