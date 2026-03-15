import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  static const _baseUrl =
      'https://69b592dfbe587338e71630e2.mockapi.io/products';

  Future<List<Product>> fetchProducts({
    required int page,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?page=$page&limit=$limit&sortBy=createdAt&order=desc',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Không thể tải danh sách sản phẩm.');
    }

    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => Product.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
