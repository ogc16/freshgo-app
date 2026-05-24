import 'package:flutter/foundation.dart';
import '../utils/database_service.dart';
import '../utils/supabase.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = 'Namukasa Sarah';
  String _phone = '+256 77X XXX XXX';
  String _email = 'sarah@freshgo.com';
  String _address = 'Kampala, Uganda';
  bool _saving = false;

  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get address => _address;
  bool get saving => _saving;

  Future<void> loadFromSupabase() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final profile = await DatabaseService.getProfile(user.id);
    if (profile != null) {
      _name = profile['name'] as String? ?? _name;
      _phone = profile['phone'] as String? ?? _phone;
      _email = profile['email'] as String? ?? _email;
      _address = profile['address'] as String? ?? _address;
      notifyListeners();
    }
  }

  Future<void> saveToSupabase() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    _saving = true;
    notifyListeners();
    try {
      await DatabaseService.upsertProfile({
        'id': user.id,
        'name': _name,
        'phone': _phone,
        'email': _email,
        'address': _address,
      });
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  void updateName(String v) { _name = v; notifyListeners(); }
  void updatePhone(String v) { _phone = v; notifyListeners(); }
  void updateEmail(String v) { _email = v; notifyListeners(); }
  void updateAddress(String v) { _address = v; notifyListeners(); }

  void updateAll({String? name, String? phone, String? email, String? address}) {
    if (name != null) _name = name;
    if (phone != null) _phone = phone;
    if (email != null) _email = email;
    if (address != null) _address = address;
    notifyListeners();
  }
}
