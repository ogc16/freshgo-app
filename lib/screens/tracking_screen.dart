import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../i18n/strings.dart';
import '../providers/locale_provider.dart';

import '../widgets/ui.dart';

List<Map<String, String>> _steps(String locale) => [
  {'icon': '\u2713', 'label': tr('tracking.orderConfirmed', locale), 'sub': tr('tracking.orderConfirmedSub', locale), 'time': '2:14 PM'},
  {'icon': '\u2713', 'label': tr('tracking.preparingOrder', locale), 'sub': tr('tracking.preparingOrderSub', locale), 'time': '2:18 PM'},
  {'icon': '\u{1F6F5}', 'label': tr('tracking.outForDelivery', locale), 'sub': tr('tracking.outForDeliverySub', locale), 'time': tr('timeslot.now', locale)},
  {'icon': '\u{1F3E0}', 'label': tr('tracking.delivered', locale), 'sub': tr('tracking.deliveredSub', locale), 'time': '~2:44 PM'},
];

class TrackingScreen extends StatefulWidget {
  final String orderId;
  final VoidCallback onContinue;
  const TrackingScreen({super.key, required this.orderId, required this.onContinue});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Position? _userPosition;
  bool _locationReady = false;
  String _locationError = '';

  final double _riderLat = 0.3152;
  final double _riderLng = 32.5850;
  double _riderProgress = 0.0;
  Timer? _riderTimer;
  Timer? _etaTimer;
  int _remainingSeconds = 22 * 60;

  @override
  void initState() {
    super.initState();
    _initLocation();
    _riderTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted) return;
      setState(() {
        if (_riderProgress < 1.0) {
          _riderProgress = (_riderProgress + 0.003).clamp(0.0, 1.0);
        }
      });
    });
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
      });
    });
  }

  @override
  void dispose() {
    _riderTimer?.cancel();
    _etaTimer?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationError = 'Location services disabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationError = 'Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _locationError = 'Location permanently denied');
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      if (mounted) setState(() { _userPosition = pos; _locationReady = true; });
    } catch (e) {
      setState(() => _locationError = 'Could not get location');
    }
  }

  double get _distanceKm {
    if (_userPosition == null) return 4.8;
    const R = 6371.0;
    final dLat = _riderLat - _userPosition!.latitude;
    final dLng = _riderLng - _userPosition!.longitude;
    final dist = sqrt(dLat * dLat + dLng * dLng) * R * pi / 180 * 110;
    final remaining = dist * (1.0 - _riderProgress);
    return remaining.clamp(0.1, 50.0);
  }

  String get _etaText {
    final etaMin = max(1, (_remainingSeconds / 60).round());
    if (etaMin < 2) return '~1 min';
    return '~$etaMin mins';
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final steps = _steps(locale);
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          decoration: const BoxDecoration(color: green),
          child: Column(
            children: [
              Text('Order #FG-${widget.orderId}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
              const SizedBox(height: 4),
              Text(tr('tracking.onTheWay', locale),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('\u{1F4CD}', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 6),
                        Text(
                          '${_distanceKm.toStringAsFixed(1)} km \u2022 $_etaText',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: green3,
                  borderRadius: BorderRadius.circular(rad),
                  border: Border.all(color: const Color(0xFFC8E6C9), width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(rad),
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size.infinite,
                        painter: _RoutePainter(progress: _riderProgress),
                      ),
                      Positioned(
                        right: 24, top: 24,
                        child: Column(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: const Center(child: Text('\u{1F3E0}', style: TextStyle(fontSize: 20))),
                            ),
                            const SizedBox(height: 4),
                            Text(tr('tracking.delivered', locale),
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: green)),
                          ],
                        ),
                      ),
                      if (_locationReady)
                        Positioned(
                          left: 20, bottom: 48,
                          child: Column(
                            children: [
                              _PulsingDot(),
                              const SizedBox(height: 4),
                              Text('You', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: info)),
                            ],
                          ),
                        )
                      else if (_locationError.isNotEmpty)
                        Positioned(
                          left: 20, bottom: 48,
                          child: Column(
                            children: [
                              Container(
                                width: 16, height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('You', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: txt3)),
                            ],
                          ),
                        ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        left: 20 + (screenWidth - 100) * _riderProgress * 0.55,
                        top: 28,
                        child: Column(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: const Center(child: Text('\u{1F6F5}', style: TextStyle(fontSize: 22))),
                            ),
                            const SizedBox(height: 4),
                            Text(tr('tracking.outForDelivery', locale),
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: green)),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8, left: 0, right: 0,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _riderProgress,
                                  backgroundColor: Colors.white.withValues(alpha: 0.5),
                                  valueColor: const AlwaysStoppedAnimation<Color>(green),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(tr('tracking.liveTracking', locale),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF546E7A), fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8E4DF), width: 0.5),
                ),
                child: Row(
                  children: [
                    const Text('\u{1F9D1}', style: TextStyle(fontSize: 34)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mugisha Ronald', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12, color: txt3),
                              children: [
                                TextSpan(text: '${tr('tracking.yourRider', locale)}  '),
                                const TextSpan(text: '\u2B50 4.9 (312)', style: TextStyle(color: amber, fontWeight: FontWeight.w700)),
                                const TextSpan(text: ' deliveries'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: ['\u{1F4DE}', '\u{1F4AC}'].map((icon) => Container(
                        width: 38, height: 38,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(color: green3, shape: BoxShape.circle),
                        child: Center(child: Text(icon, style: const TextStyle(fontSize: 16))),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(icon: '\u{1F4CD}', value: '${_distanceKm.toStringAsFixed(1)} km', label: 'Distance'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(icon: '\u23F1', value: _etaText, label: 'ETA'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(icon: '\u{1F4E6}', value: '${(_riderProgress * 100).round()}%', label: 'Progress'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(rad),
                  border: Border.all(color: const Color(0xFFE8E4DF), width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('tracking.orderProgress', locale).toUpperCase(),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: txt3, letterSpacing: 0.6)),
                    const SizedBox(height: 14),
                    ...List.generate(steps.length, (i) {
                      final done = i < 2 || (i == 2 && _riderProgress > 0.05);
                      final active = i == 2;
                      final step = steps[i];
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 32,
                              child: Column(
                                children: [
                                  Container(
                                    width: 32, height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: done ? green : (active ? Colors.white : const Color(0xFFF5F5F5)),
                                      border: active ? Border.all(color: green, width: 2) : null,
                                    ),
                                    child: Center(
                                      child: Text(step['icon'] as String,
                                          style: TextStyle(fontSize: done ? 13 : 16)),
                                    ),
                                  ),
                                  if (i < steps.length - 1)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: done ? green : const Color(0xFFEEEEEE),
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(step['label'] as String,
                                      style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.w700,
                                        color: active ? green : (done ? txt : const Color(0xFFAAAAAA)),
                                      )),
                                  const SizedBox(height: 1),
                                  Text(step['sub'] as String,
                                      style: const TextStyle(fontSize: 12, color: txt3)),
                                  const SizedBox(height: 3),
                                  Text(step['time'] as String,
                                      style: TextStyle(
                                        fontSize: 11, fontWeight: FontWeight.w700,
                                        color: active ? amber : (done ? green : txt3),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              OutlineButton(text: tr('tracking.continueShopping', locale), onPressed: widget.onContinue),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoutePainter extends CustomPainter {
  final double progress;
  _RoutePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8F5EE);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final gridPaint = Paint()
      ..color = const Color(0xFFD5E8D8)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final startX = 40.0;
    final startY = 50.0;
    final endX = size.width - 50;
    final endY = size.height - 60;

    final path = Path();
    path.moveTo(startX, startY);
    final midX = (startX + endX) / 2;
    path.cubicTo(midX, startY - 20, midX, endY + 20, endX, endY);

    final dashPaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    _drawDashedPath(canvas, path, dashPaint);

    final metrics = path.computeMetrics();
    double totalLength = 0;
    for (final m in metrics) { totalLength += m.length; }

    final filledPaint = Paint()
      ..color = green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    double drawn = 0;
    for (final m in metrics) {
      final len = m.length;
      final drawLen = (progress * totalLength - drawn).clamp(0.0, len);
      if (drawLen > 0) {
        final extracted = m.extractPath(0, drawLen);
        canvas.drawPath(extracted, filledPaint);
      }
      drawn += len;
    }

    final dotPaint = Paint()..color = green..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(endX, endY), 6, dotPaint);
    final dotBorder = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawCircle(Offset(endX, endY), 6, dotBorder);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final len = min(6.0, metric.length - distance);
        final extracted = metric.extractPath(distance, distance + len);
        canvas.drawPath(extracted, paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) => old.progress != progress;
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) => Transform.scale(
        scale: _animation.value,
        child: child,
      ),
      child: Container(
        width: 16, height: 16,
        decoration: BoxDecoration(
          color: info,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(color: info.withValues(alpha: 0.4), blurRadius: 6),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon, value, label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E4DF), width: 0.5),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: txt)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: txt3, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
