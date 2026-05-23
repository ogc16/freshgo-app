import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/ui.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const FreshGoApp(),
    ),
  );
}

class FreshGoApp extends StatelessWidget {
  const FreshGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.light(
          primary: green,
          secondary: amber,
        ),
      ),
      home: const PhoneFrame(),
    );
  }
}

class PhoneFrame extends StatefulWidget {
  const PhoneFrame({super.key});

  @override
  State<PhoneFrame> createState() => _PhoneFrameState();
}

class _PhoneFrameState extends State<PhoneFrame> {
  String _screen = 'login';
  String _phone = '';
  String _orderId = '';

  void _navigate(String s) => setState(() => _screen = s);

  void _handleLogin(String p) {
    setState(() {
      _phone = p;
      _screen = 'otp';
    });
  }

  void _handleVerify() => setState(() => _screen = 'home');

  void _handlePlaceOrder() {
    final id = Random().nextInt(90000) + 10000;
    setState(() {
      _orderId = id.toString();
      context.read<CartProvider>().clearCart();
      _screen = 'tracking';
    });
  }

  bool get _isDarkTop => _screen == 'login' || _screen == 'otp' || _screen == 'home';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameWidth = min(size.width * 0.9, 390.0);
    final frameHeight = min(size.height * 0.9, 844.0);

    return Scaffold(
      body: Center(
        child: Container(
          width: frameWidth,
          height: frameHeight,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(44),
            boxShadow: const [
              BoxShadow(color: Color(0x99000000), blurRadius: 80, offset: Offset(0, 30)),
              BoxShadow(color: Color(0xFF1a1a1a), blurRadius: 0, spreadRadius: 10),
              BoxShadow(color: Color(0xFF333333), blurRadius: 0, spreadRadius: 12),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
                decoration: BoxDecoration(
                  color: _isDarkTop ? green : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('9:41',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _isDarkTop ? Colors.white : Colors.black,
                        )),
                    Row(
                      children: [
                        const Icon(Icons.signal_cellular_alt, size: 14, color: txt2),
                        const SizedBox(width: 6),
                        const Icon(Icons.battery_full, size: 16, color: txt2),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: KeyedSubtree(
                    key: ValueKey('${_screen}_${context.watch<LocaleProvider>().locale}'),
                    child: _buildScreen(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8, top: 6),
                decoration: BoxDecoration(
                  color: _screen == 'login' ? green : Colors.white,
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_screen) {
      case 'login':
        return LoginScreen(onLogin: _handleLogin);
      case 'otp':
        return OtpScreen(phone: _phone, onVerify: _handleVerify, onBack: () => _navigate('login'));
      case 'home':
        return HomeScreen(onNavigate: _navigate);
      case 'checkout':
        return CheckoutScreen(onBack: () => _navigate('home'), onContinue: () => _navigate('payment'));
      case 'payment':
        return PaymentScreen(onBack: () => _navigate('checkout'), onPlaceOrder: _handlePlaceOrder);
      case 'tracking':
        return TrackingScreen(orderId: _orderId, onContinue: () => _navigate('home'));
      case 'orders':
        return OrdersScreen(onNavigate: _navigate, onViewTracking: () => _navigate('tracking'));
      case 'profile':
        return ProfileScreen(onNavigate: _navigate, onLogout: () => _navigate('login'));
    }
    return LoginScreen(onLogin: _handleLogin);
  }
}
