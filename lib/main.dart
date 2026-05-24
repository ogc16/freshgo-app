import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/cart_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/loyalty_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/loyalty_screen.dart';
import 'utils/supabase.dart';
import 'widgets/ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const FoodApp(),
    ),
  );
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodApp',
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

  void _handleLogin(String email) {
    context.read<AuthProvider>().signInWithEmail(email, 'password123');
  }

  void _handleSignUp() {
    setState(() => _screen = 'otp');
  }

  void _handleGuestLogin() {
    context.read<AuthProvider>().signInAnonymously();
  }

  void _handlePhoneLogin(String phone) {
    setState(() {
      _phone = phone;
      _screen = 'otp';
    });
    context.read<AuthProvider>().signInWithPhone(phone);
  }

  void _handleVerify(String code) {
    context.read<AuthProvider>().verifyOtp(_phone, code).then((ok) {
      if (ok && mounted) setState(() => _screen = 'home');
    });
  }

  void _handlePlaceOrder() {
    final id = Random().nextInt(90000) + 10000;
    setState(() {
      _orderId = id.toString();
      context.read<CartProvider>().clearCart();
      _screen = 'tracking';
    });
  }

  bool get _isDarkTop => _screen == 'login' || _screen == 'otp' || _screen == 'loyalty';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isAuthenticated && _screen == 'login') {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _screen = 'home'));
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkTop ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
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
      ),
    );
  }

  Widget _buildScreen() {
    switch (_screen) {
      case 'login':
        return LoginScreen(onLogin: _handleLogin, onSignUp: _handleSignUp, onGuestLogin: _handleGuestLogin, onPhoneLogin: _handlePhoneLogin);
      case 'otp':
        return OtpScreen(phone: _phone, onVerify: _handleVerify, onBack: () => _navigate('login'));
      case 'home':
        return HomeScreen(onNavigate: _navigate);
      case 'checkout':
        return CheckoutScreen(onBack: () => _navigate('home'), onContinue: () => _navigate('payment'));
      case 'payment':
        return PaymentScreen(onBack: () => _navigate('checkout'), onPlaceOrder: _handlePlaceOrder);
      case 'loyalty':
        return LoyaltyScreen(onNavigate: _navigate);
      case 'tracking':
        return TrackingScreen(orderId: _orderId, onContinue: () => _navigate('home'));
      case 'orders':
        return OrdersScreen(onNavigate: _navigate, onViewTracking: () => _navigate('tracking'));
      case 'profile':
        return ProfileScreen(onNavigate: _navigate, onLogout: () {
          context.read<AuthProvider>().signOut();
          setState(() => _screen = 'login');
        });
    }
    return LoginScreen(onLogin: _handleLogin, onSignUp: _handleSignUp, onGuestLogin: _handleGuestLogin, onPhoneLogin: _handlePhoneLogin);
  }
}
