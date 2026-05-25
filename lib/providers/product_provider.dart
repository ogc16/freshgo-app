import 'package:flutter/foundation.dart';
import '../data/products.dart' as fallback;
import '../models/product.dart';
import '../utils/database_service.dart';

class ProductProvider extends ChangeNotifier {
  Map<String, List<Product>> _products = {};
  List<Product> _allProducts = [];
  bool _loaded = false;
  bool _loading = false;

  Map<String, List<Product>> get products => _products;
  List<Product> get allProducts => _allProducts;

  static Map<String, Map<String, String>> get categoryMeta => fallback.categoryMeta;

  List<Product> _parseRows(List<Map<String, dynamic>> rows) {
    return rows.map((r) => Product.fromMap(r)).toList();
  }

  void _parseFallback() {
    final map = <String, List<Product>>{};
    for (final entry in fallback.products.entries) {
      map[entry.key] = _parseRows(entry.value);
    }
    _products = map;
    _allProducts = map.values.expand((l) => l).toList();
  }

  Future<void> load() async {
    if (_loaded || _loading) return;
    _loading = true;
    notifyListeners();
    try {
      final rows = await DatabaseService.getProducts();
      if (rows.isEmpty) {
        _parseFallback();
      } else {
        final map = <String, List<Product>>{};
        for (final row in rows) {
          final p = Product.fromMap(row);
          map.putIfAbsent(p.category, () => []).add(p);
        }
        _products = map;
        _allProducts = map.values.expand((l) => l).toList();
      }
      _loaded = true;
    } catch (_) {
      _parseFallback();
      _loaded = true;
    }
    _loading = false;
    notifyListeners();
  }
}
