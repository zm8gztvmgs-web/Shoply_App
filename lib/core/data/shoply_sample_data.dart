import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shoply_app/core/model/categories/ressponse_categories.dart';
import 'package:shoply_app/core/model/products/response_products.dart';

/// Read-only product catalog supplied for the course. User data stays in Firebase.
class ShoplySampleData {
  static Future<Map<String, dynamic>>? _cached;

  static Future<Map<String, dynamic>> _load() => _cached ??= _read();

  static Future<Map<String, dynamic>> _read() async {
    final text = await rootBundle.loadString('assets/data/shoply_products.json');
    return jsonDecode(text) as Map<String, dynamic>;
  }

  static Future<List<RessponseCategories>> getCategories() async {
    final data = await _load();
    return (data['categories'] as List)
        .map((item) => RessponseCategories.fromJson(
            Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  // The supplied JSON has no categoryId field. These assignments match
  // the supplied product IDs and their listed product names.
  static const Map<String, String> _categoryByProductId = {
    'p90': 'shoes', 'p92': 'shoes',
    'p85': 'clothes', 'p86': 'clothes',
    'p175': 'bags', 'p176': 'bags',
    'p93': 'accessories', 'p94': 'accessories',
    'p6': 'beauty', 'p8': 'beauty',
  };

  static Future<List<ResponseProducts>> getProducts({String? categoryId}) async {
    final data = await _load();
    final items = (data['products'] as List)
        .map((item) => Map<String, dynamic>.from(item as Map));
    return items
        .where((item) => categoryId == null ||
            _categoryByProductId[item['id']] == categoryId)
        .map(ResponseProducts.fromJson)
        .toList();
  }

  static Future<List<ResponseProducts>> getTrendingProducts() async {
    final products = await getProducts();
    return products.where((product) => product.isTrending == true).toList();
  }
}
