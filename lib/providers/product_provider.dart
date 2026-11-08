import 'package:flutter/foundation.dart';

import '../services/api_service_products.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ApiServiceProducts _api = ApiServiceProducts();

  List<Product> _products = [];
  List<String> _categoryList = [];
  bool _loading = false;
  int _total = 0;
  String _selectedCategory = '';

  List<Product> get products => _products;
  List<String> get categoryList => _categoryList;
  bool get loading => _loading;
  int get total => _total;
  String get selectedCategory => _selectedCategory;

  Future<void> fetchProducts({int limit = 30, int skip = 0}) async {
    _loading = true;
    notifyListeners();

    try {
      final res = await _api.getAllProducts(limit: limit, skip: skip);
      _products = res.products;
      _total = res.total;
    } catch (e) {
      debugPrint('Error fetchProducts: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      _categoryList = await _api.getCategoryList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetchCategories: $e');
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) return fetchProducts();

    _loading = true;
    notifyListeners();

    try {
      final res = await _api.searchProducts(query);
      _products = res.products;
    } catch (e) {
      debugPrint('Error searchProducts: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    _loading = true;
    notifyListeners();

    try {
      final res = await _api.getProductsByCategory(category);
      _products = res.products;
    } catch (e) {
      debugPrint('Error filterByCategory: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> updateProduct(int id, Product updated) async {
    _loading = true;
    notifyListeners();

    try {
      final result = await _api.updateProduct(id, updated.toJson());
      int idx = _products.indexWhere((p) => p.id == id);
      if (idx != -1) {
        _products[idx] = result;
      }
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updateProduct: $e');
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
