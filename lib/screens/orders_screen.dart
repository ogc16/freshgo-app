import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../utils/formatters.dart';
import '../widgets/ui.dart';

const _orders = [
  {'id': 'FG-38219', 'date': 'Today, 2:14 PM', 'status': 'transit', 'items': ['\u{1F345}', '\u{1F35A}', '\u{1F4A7}'], 'count': 3, 'total': 34000},
  {'id': 'FG-37104', 'date': 'Yesterday, 11:30 AM', 'status': 'delivered', 'items': ['\u{1F35B}', '\u{1F966}', '\u{1F534}'], 'count': 5, 'total': 118000},
  {'id': 'FG-36881', 'date': 'Apr 22, 9:00 AM', 'status': 'delivered', 'items': ['\u{1F4A7}', '\u{1F9C5}', '\u{1F35E}'], 'count': 4, 'total': 28000},
  {'id': 'FG-36102', 'date': 'Apr 19, 7:30 PM', 'status': 'delivered', 'items': ['\u{1F95A}', '\u{1FAF9}', '\u{1F34C}'], 'count': 6, 'total': 46000},
];

class OrdersScreen extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  final VoidCallback onViewTracking;
  const OrdersScreen({super.key, required this.onNavigate, required this.onViewTracking});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return Column(
      children: [
        PageHeader(title: tr('orders.title', locale), onBack: () => onNavigate('home')),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
            children: _orders.map((order) {
              final isTransit = order['status'] == 'transit';
              return GestureDetector(
                onTap: isTransit ? onViewTracking : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(rad),
                    border: Border.all(color: const Color(0xFFE8E4DF), width: 0.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order #${order['id']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(order['date'] as String, style: const TextStyle(fontSize: 11, color: txt3)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isTransit ? const Color(0xFFFFF3D6) : green3,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isTransit ? tr('orders.inTransit', locale) : tr('orders.delivered', locale),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                                  color: isTransit ? const Color(0xFF9A6800) : green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ...((order['items'] as List).take(3)).map((emoji) => Container(
                            width: 38, height: 38,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                            child: Center(child: Text(emoji as String, style: const TextStyle(fontSize: 20))),
                          )),
                          if ((order['count'] as int) > 3)
                            Container(
                              width: 38, height: 38,
                              decoration: BoxDecoration(color: green3, borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text('+${(order['count'] as int) - 3}',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: green)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${order['count']} ${tr('home.items', locale)}', style: const TextStyle(fontSize: 13, color: txt2)),
                          Text(fmt(order['total'] as int),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: green)),
                        ],
                      ),
                      if (isTransit) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Color(0xFFF0ECE6), width: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: amber,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(tr('orders.liveTracking', locale),
                                  style: const TextStyle(fontSize: 12, color: amber, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        BottomNav(active: 'orders', onNavigate: onNavigate),
      ],
    );
  }
}
