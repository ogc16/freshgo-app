import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';
import '../providers/loyalty_provider.dart';
import '../utils/formatters.dart' show fmt;
import '../widgets/ui.dart';

class LoyaltyScreen extends StatelessWidget {
  final ValueChanged<String> onNavigate;
  const LoyaltyScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final loyalty = context.watch<LoyaltyProvider>();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          decoration: const BoxDecoration(color: green),
          child: Column(
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
                ),
                child: const Center(child: Text('\u{1F3C6}', style: TextStyle(fontSize: 30))),
              ),
              const SizedBox(height: 12),
              Text(tr('loyalty.points', locale), style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
              const SizedBox(height: 4),
              Text('${loyalty.points}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () => _simulateScan(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: green3,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: green.withValues(alpha: 0.3), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 28)),
                        ),
                        const SizedBox(height: 12),
                        Text(tr('loyalty.scanQr', locale), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: green)),
                        const SizedBox(height: 4),
                        Text(tr('loyalty.scanToEarn', locale), style: const TextStyle(fontSize: 12, color: txt3)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('loyalty.pastReceipts', locale), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    Text('${loyalty.receipts.length}', style: const TextStyle(fontSize: 13, color: txt3)),
                  ],
                ),
                const SizedBox(height: 12),
                if (loyalty.receipts.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Text('\u{1F4CB}', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text(tr('loyalty.noReceipts', locale), style: const TextStyle(fontSize: 13, color: txt3), textAlign: TextAlign.center),
                      ],
                    ),
                  )
                else
                  ...loyalty.receipts.reversed.map((r) => _ReceiptTile(receipt: r, locale: locale)),
              ],
            ),
          ),
        ),
        BottomNav(active: 'loyalty', onNavigate: onNavigate),
      ],
    );
  }

  void _simulateScan(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _ScanDialog(),
    );
  }
}

class _ScanDialog extends StatefulWidget {
  const _ScanDialog();

  @override
  State<_ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<_ScanDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.forward().then((_) {
      if (mounted) {
        final points = Random().nextInt(41) + 10;
        final stores = ['FreshGo Mart', 'Green Grocers', 'City Supermarket', 'Farm Fresh', 'Daily Needs Store'];
        final rng = Random();
        final receipt = Receipt(
          storeName: stores[rng.nextInt(stores.length)],
          date: DateTime.now(),
          amount: (rng.nextInt(81) + 20) * 1000,
          pointsEarned: points,
        );
        context.read<LoyaltyProvider>().addReceipt(receipt);
        Navigator.of(context).pop();
        _showResult(context, points);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80, height: 80,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => CustomPaint(
                  painter: _ScanPainter(progress: _controller.value),
                  child: child,
                ),
                child: const Center(child: Icon(Icons.qr_code_scanner, size: 36, color: green)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Scanning...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Point your camera at the store QR code', style: TextStyle(fontSize: 13, color: txt3)),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, int points) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: green3,
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Icon(Icons.check_circle, color: green, size: 36)),
              ),
              const SizedBox(height: 16),
              const Text('QR Scanned!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('+$points points', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: green)),
              const SizedBox(height: 4),
              Text('Points earned', style: TextStyle(fontSize: 13, color: txt3)),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Great!',
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  final double progress;
  _ScanPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = green.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    canvas.drawRect(rect, paint);
    final linePaint = Paint()
      ..color = green
      ..strokeWidth = 2;
    final y = 4 + (size.height - 8) * progress;
    canvas.drawLine(Offset(4, y), Offset(size.width - 4, y), linePaint);
  }

  @override
  bool shouldRepaint(_ScanPainter old) => old.progress != progress;
}

class _ReceiptTile extends StatelessWidget {
  final Receipt receipt;
  final String locale;
  const _ReceiptTile({required this.receipt, required this.locale});

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${receipt.date.day} ${months[receipt.date.month - 1]} ${receipt.date.year}';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F2EE), width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: green3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('\u{1F4E6}', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(receipt.storeName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('${fmt(receipt.amount)} \u2022 $dateStr', style: const TextStyle(fontSize: 12, color: txt3)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: green3,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('+${receipt.pointsEarned}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: green)),
          ),
        ],
      ),
    );
  }
}
