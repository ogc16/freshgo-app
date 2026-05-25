import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/cart_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/loyalty_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
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
  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  } catch (_) {}
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const FoodApp(),
    ),
  );
}

class FoodApp extends StatefulWidget {
  const FoodApp({super.key});

  @override
  State<FoodApp> createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

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
      home: _showSplash
          ? const Scaffold(
              backgroundColor: green,
              body: Center(
                child: Text(
                  'freshgo',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: amber,
                  ),
                ),
              ),
            )
          : const PhoneFrame(),
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

  void _handleLogin(String email, String password) {
    context.read<AuthProvider>().signInWithEmail(email, password);
  }

  void _handleSignUp() {
    setState(() => _screen = 'signup');
  }

  void _handleGuestLogin() {
    context.read<AuthProvider>().signInAnonymously();
  }

  Future<void> _handlePhoneLogin(String phone) async {
    final err = await context.read<AuthProvider>().signInWithPhone(phone);
    if (err == null && mounted) {
      setState(() {
        _phone = phone;
        _screen = 'otp';
      });
    }
  }

  void _handleVerify(String code) {
    context.read<AuthProvider>().verifyOtp(_phone, code).then((ok) {
      if (ok && mounted) setState(() => _screen = 'home');
    });
  }

  void _handlePlaceOrder() {
    final id = Random().nextInt(90000) + 10000;
    final cart = context.read<CartProvider>();
    context.read<OrderProvider>().addOrder(id.toString(), cart.cartItems, cart.cartTotal);
    setState(() {
      _orderId = id.toString();
      cart.clearCart();
      _screen = 'tracking';
    });
  }

  bool get _isDarkTop => _screen == 'login' || _screen == 'otp' || _screen == 'loyalty' || _screen == 'signup';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isAuthenticated && _screen == 'login') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<OrderProvider>().loadFromSupabase();
        setState(() => _screen = 'home');
      });
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkTop ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: ConnectivityBanner(
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
      ),
    );
  }

  Widget _buildScreen() {
    switch (_screen) {
      case 'login':
        return LoginScreen(onLogin: _handleLogin, onSignUp: _handleSignUp, onGuestLogin: _handleGuestLogin, onPhoneLogin: _handlePhoneLogin);
      case 'signup':
        return SignUpScreen(onBack: () => _navigate('login'));
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
