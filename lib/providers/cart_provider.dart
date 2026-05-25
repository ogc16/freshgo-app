import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'product_provider.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, int> _cart = {};
  Map<int, Product>? _productCache;
  bool _cartOpen = false;

  Map<int, int> get cart => _cart;
  bool get cartOpen => _cartOpen;

  void cacheFromProvider(ProductProvider p) {
    _productCache ??= {for (final prod in p.allProducts) prod.id: prod};
  }

  Product? _product(int id) => _productCache?[id];

  void addItem(int id) {
    _cart[id] = (_cart[id] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(int id) {
    if (_cart.containsKey(id)) {
      if (_cart[id]! > 1) {
        _cart[id] = _cart[id]! - 1;
      } else {
        _cart.remove(id);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void toggleCart() {
    _cartOpen = !_cartOpen;
    notifyListeners();
  }

  void openCart() {
    _cartOpen = true;
    notifyListeners();
  }

  void closeCart() {
    _cartOpen = false;
    notifyListeners();
  }

  int get itemCount => _cart.values.fold(0, (a, b) => a + b);

  int get cartTotal {
    int total = 0;
    _cart.forEach((id, qty) {
      final p = _product(id);
      if (p != null) total += p.price * qty;
    });
    return total;
  }

  List<MapEntry<Product, int>> get cartItems {
    return _cart.entries.map((e) {
      final p = _product(e.key)!;
      return MapEntry(p, e.value);
    }).toList();
  }
}
