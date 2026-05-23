import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/formatters.dart';
import '../widgets/ui.dart';

const _methods = [
  {'id': 'mtn', 'icon': '\u{1F49B}', 'label': 'MTN Mobile Money', 'sub': 'Pay with MTN MoMo', 'bg': Color(0xFFFFF3D6), 'border': Color(0xFFFBC02D)},
  {'id': 'airtel', 'icon': '\u{2764}\u{FE0F}', 'label': 'Airtel Money', 'sub': 'Pay with Airtel Money', 'bg': Color(0xFFFFE8E8), 'border': Color(0xFFEF5350)},
  {'id': 'card', 'icon': '\u{1F4B3}', 'label': 'Visa / Mastercard', 'sub': 'Credit or debit card', 'bg': Color(0xFFE3F2FD), 'border': info},
  {'id': 'cod', 'icon': '\u{1F4B5}', 'label': 'Cash on Delivery', 'sub': 'Pay when order arrives', 'bg': green3, 'border': green},
];

class PaymentScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onPlaceOrder;
  const PaymentScreen({super.key, required this.onBack, required this.onPlaceOrder});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'mtn';
  bool _loading = false;
  final _mtnController = TextEditingController();
  final _airtelController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _mtnController.dispose();
    _airtelController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handlePlace() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      setState(() => _loading = false);
      widget.onPlaceOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final locale = context.watch<LocaleProvider>().locale;
    return Column(
      children: [
        PageHeader(title: tr('payment.title', locale), onBack: widget.onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: amberBg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Text('\u{1F4B0}', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('payment.totalToPay', locale), style: const TextStyle(fontSize: 12, color: Color(0xFF9A6800), fontWeight: FontWeight.w600)),
                        Text(fmt(cart.cartTotal), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF9A6800))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: tr('payment.selectMethod', locale).toUpperCase(),
                child: Column(
                  children: _methods.map((m) {
                    final isActive = m['id'] == _method;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _method = m['id'] as String),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isActive ? green3 : Colors.white,
                              border: Border.all(color: isActive ? green : border, width: 1.5),
                              borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(12),
                                bottom: isActive ? Radius.zero : const Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(color: m['bg'] as Color, borderRadius: BorderRadius.circular(10)),
                                  child: Center(child: Text(m['icon'] as String, style: const TextStyle(fontSize: 22))),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(m['label'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 2),
                                      Text(m['sub'] as String, style: const TextStyle(fontSize: 12, color: txt2)),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isActive ? green : const Color(0xFFCCCCCC), width: 2),
                                  ),
                                  child: isActive
                                      ? Center(child: Container(
                                          width: 10, height: 10,
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: green),
                                        ))
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFAFAF8),
                              border: Border(
                                left: BorderSide(color: green, width: 1.5),
                                right: BorderSide(color: green, width: 1.5),
                                bottom: BorderSide(color: green, width: 1.5),
                              ),
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                            ),
                            child: _buildMethodInput(m['id'] as String, locale),
                          ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
              PrimaryButton(text: tr('payment.placeOrder', locale), onPressed: _handlePlace, loading: _loading, disabled: _loading),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(tr('payment.secured', locale),
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: txt3)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMethodInput(String id, String locale) {
    switch (id) {
      case 'mtn':
        return FormInput(
          hintText: tr('payment.mtnHint', locale),
          controller: _mtnController,
          keyboardType: TextInputType.phone,
          prefix: _prefixWidget(),
        );
      case 'airtel':
        return FormInput(
          hintText: tr('payment.airtelHint', locale),
          controller: _airtelController,
          keyboardType: TextInputType.phone,
          prefix: _prefixWidget(),
        );
      case 'card':
        return Column(
          children: [
            FormInput(hintText: tr('payment.cardHint', locale), controller: _cardController, margin: const EdgeInsets.only(bottom: 8)),
            Row(
              children: [
                Expanded(child: FormInput(hintText: tr('payment.expiryHint', locale), controller: _expiryController, margin: const EdgeInsets.only(right: 8))),
                Expanded(child: FormInput(hintText: tr('payment.cvvHint', locale), controller: _cvvController)),
              ],
            ),
          ],
        );
      case 'cod':
        return Text(
          tr('payment.codInfo', locale),
          style: const TextStyle(fontSize: 13, color: txt2, height: 1.5),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _prefixWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(radButton), color: Colors.white),
      child: const Text('\u{1F1FA}\u{1F1EC} +256', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: txt)),
    );
  }
}
