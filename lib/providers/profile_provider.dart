import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = 'Namukasa Sarah';
  String _phone = '+256 77X XXX XXX';
  String _email = 'sarah@freshgo.com';
  String _address = 'Kampala, Uganda';

  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get address => _address;

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
