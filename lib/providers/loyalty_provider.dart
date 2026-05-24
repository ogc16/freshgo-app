import 'package:flutter/foundation.dart';

class Receipt {
  final String storeName;
  final DateTime date;
  final int amount;
  final int pointsEarned;

  const Receipt({
    required this.storeName,
    required this.date,
    required this.amount,
    required this.pointsEarned,
  });
}

class LoyaltyProvider extends ChangeNotifier {
  int _points = 0;
  final List<Receipt> _receipts = [];

  int get points => _points;
  List<Receipt> get receipts => List.unmodifiable(_receipts);

  void addPoints(int amount) {
    _points += amount;
    notifyListeners();
  }

  void addReceipt(Receipt receipt) {
    _receipts.add(receipt);
    _points += receipt.pointsEarned;
    notifyListeners();
  }
}
