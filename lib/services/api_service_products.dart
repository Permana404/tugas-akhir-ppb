import 'package:dio/dio.dart';

import '../models/product_model.dart';

class ApiServiceProducts {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost/toko_backend',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<ProductsResponse> getAllProducts({
    int limit = 30,
    int skip = 0,
  }) async {
    final res = await _dio.get('/api.php');

    List listData = [];
    if (res.data is List) {
      listData = res.data;
    } else if (res.data is Map) {
      listData = res.data['products'] ?? [];
    }

    List<Product> parsedProducts = [];
    for (var item in listData) {
      if (item is Map) {
        // Normalisasi data agar sesuai dengan model Product
        final normalizedData = Map<String, dynamic>.from(item);
        if (normalizedData['id'] != null) {
          normalizedData['id'] =
              int.tryParse(normalizedData['id'].toString()) ?? 0;
        }
        if (normalizedData['price'] != null) {
          normalizedData['price'] =
              double.tryParse(normalizedData['price'].toString()) ?? 0.0;
        }
        // Pastikan field category tersedia agar tidak error
        if (!normalizedData.containsKey('category') ||
            normalizedData['category'] == null) {
          normalizedData['category'] = 'Umum';
        }

        try {
          parsedProducts.add(Product.fromJson(normalizedData));
        } catch (e) {
          // Abaikan jika ada item yang gagal dipetakan
        }
      }
    }

    return ProductsResponse(
      products: parsedProducts,
      total: parsedProducts.length,
      skip: skip,
      limit: limit,
    );
  }

  Future<Product> getProduct(int id) async {
    final res = await _dio.get('/api.php', queryParameters: {'id': id});
    final item = res.data;
    final normalizedData = Map<String, dynamic>.from(item);
    normalizedData['id'] = int.tryParse(normalizedData['id'].toString()) ?? id;
    normalizedData['price'] =
        double.tryParse(normalizedData['price'].toString()) ?? 0.0;
    if (!normalizedData.containsKey('category'))
      normalizedData['category'] = 'Umum';

    return Product.fromJson(normalizedData);
  }

  Future<ProductsResponse> searchProducts(String query) async {
    final allRes = await getAllProducts();

    final filtered = allRes.products.where((p) {
      final title = p.title.toLowerCase();
      final desc = p.description.toLowerCase();
      final q = query.toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();

    return ProductsResponse(
      products: filtered,
      total: filtered.length,
      skip: 0,
      limit: 30,
    );
  }

  Future<List<String>> getCategoryList() async {
    return ['Semua Kategori'];
  }

  Future<ProductsResponse> getProductsByCategory(String category) async {
    return await getAllProducts();
  }

  Future<Product> addProduct(Map<String, dynamic> data) async {
    await _dio.post('/api.php', data: data);
    if (!data.containsKey('category')) data['category'] = 'Umum';
    return Product.fromJson(data);
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> data) async {
    final payload = {'id': id, ...data};
    await _dio.put('/api.php', data: payload);
    if (!payload.containsKey('category')) payload['category'] = 'Umum';
    return Product.fromJson(payload);
  }

  Future<Product> deleteProduct(int id) async {
    await _dio.delete('/api.php', queryParameters: {'id': id});
    return Product.fromJson({
      'id': id,
      'title': '',
      'price': 0.0,
      'description': '',
      'image': '',
      'category': 'Umum',
    });
  }
}
