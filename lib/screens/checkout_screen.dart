import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/formatters.dart';
import '../widgets/ui.dart';

class CheckoutScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;
  const CheckoutScreen({super.key, required this.onBack, required this.onContinue});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _addrType = 0;
  int _timeSlot = 0;
  bool _pinned = false;
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final locale = context.watch<LocaleProvider>().locale;
    final timeSlots = [tr('timeslot.now', locale), tr('timeslot.12-1', locale), tr('timeslot.2-3', locale), tr('timeslot.5-6', locale), tr('timeslot.tomorrow', locale)];
    final addrTypes = ['\u{1F3E0} ${tr('address.home', locale)}', '\u{1F4BC} ${tr('address.work', locale)}', '\u{1F4CD} ${tr('address.other', locale)}'];
    return Column(
      children: [
        PageHeader(title: tr('checkout.title', locale), onBack: widget.onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionCard(
                title: tr('checkout.deliveryAddress', locale).toUpperCase(),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _pinned = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 90,
                        decoration: BoxDecoration(
                          color: _pinned ? green3 : const Color(0xFFE3F2FD),
                          border: Border.all(
                            color: _pinned ? green : const Color(0xFF90CAF9),
                            width: 1.5,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_pinned ? '\u{1F4CD}' : '\u{1F5FA}\u{FE0F}', style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 8),
                            Text(
                              _pinned ? tr('checkout.pinned', locale) : tr('checkout.tapToPin', locale),
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _pinned ? green : info),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(addrTypes.length, (i) {
                        final active = i == _addrType;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
                            child: GestureDetector(
                              onTap: () => setState(() => _addrType = i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: active ? green3 : Colors.white,
                                  border: Border.all(color: active ? green : border, width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(addrTypes[i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? green : txt2)),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    FormInput(hintText: tr('checkout.streetHint', locale), controller: _streetController, margin: const EdgeInsets.only(bottom: 8)),
                    FormInput(hintText: tr('checkout.landmarkHint', locale), controller: _landmarkController),
                  ],
                ),
              ),
              SectionCard(
                title: tr('checkout.deliveryTime', locale).toUpperCase(),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(timeSlots.length, (i) {
                    final active = i == _timeSlot;
                    return GestureDetector(
                      onTap: () => setState(() => _timeSlot = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? green3 : Colors.white,
                          border: Border.all(color: active ? green : border, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(timeSlots[i],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: active ? green : txt2)),
                      ),
                    );
                  }),
                ),
              ),
              SectionCard(
                title: tr('checkout.orderSummary', locale).toUpperCase(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: ListView(
                        children: cart.cartItems.map((item) {
                          final p = item.key;
                          final qty = item.value;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF5F2EE), width: 0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${p.emoji} ${p.name} \u00D7$qty', style: const TextStyle(fontSize: 13, color: txt2)),
                                Text(fmt(p.price * qty), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tr('cart.deliveryFee', locale), style: const TextStyle(fontSize: 13, color: txt2)),
                        Text('${tr('cart.free', locale)} \u{1F389}', style: const TextStyle(fontSize: 13, color: green, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tr('checkout.total', locale), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        Text(fmt(cart.cartTotal), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: green)),
                      ],
                    ),
                  ],
                ),
              ),
              PrimaryButton(text: '${tr('checkout.continueToPayment', locale)} \u{2192}', onPressed: widget.onContinue),
            ],
          ),
        ),
      ],
    );
  }
}
