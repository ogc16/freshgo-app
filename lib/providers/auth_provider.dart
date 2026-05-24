import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/supabase.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  User? _user;
  String? _error;
  StreamSubscription<AuthState>? _authSub;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _user = supabase.auth.currentUser;
    if (_user != null) _status = AuthStatus.authenticated;
    _authSub = supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> signInWithEmail(String email, String password) async {
    setState(AuthStatus.authenticating, null);
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      setState(AuthStatus.unauthenticated, e.message);
    }
  }

  Future<String?> signUpWithEmail(String email, String password) async {
    setState(AuthStatus.authenticating, null);
    try {
      await supabase.auth.signUp(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      setState(AuthStatus.unauthenticated, e.message);
      return e.message;
    }
  }

  Future<String?> signInWithPhone(String phone) async {
    setState(AuthStatus.authenticating, null);
    try {
      await supabase.auth.signInWithOtp(phone: '+256$phone');
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      setState(AuthStatus.unauthenticated, e.message);
      return e.message;
    }
  }

  Future<bool> verifyOtp(String phone, String token) async {
    setState(AuthStatus.authenticating, null);
    try {
      await supabase.auth.verifyOTP(phone: '+256$phone', token: token, type: OtpType.sms);
      return true;
    } on AuthException catch (e) {
      setState(AuthStatus.unauthenticated, e.message);
      return false;
    }
  }

  Future<void> signInAnonymously() async {
    setState(AuthStatus.authenticating, null);
    try {
      await supabase.auth.signInAnonymously();
    } on AuthException catch (e) {
      setState(AuthStatus.unauthenticated, e.message);
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    setState(AuthStatus.unauthenticated, null);
  }

  void clearError() { _error = null; notifyListeners(); }

  void setState(AuthStatus s, String? e) {
    _status = s;
    _error = e;
    notifyListeners();
  }
}
