import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:dartz/dartz.dart';
import 'package:shoply_app/core/model/products/response_products.dart';

class ProductsUsecase {
  static const Map<String, String> _productCategories = {
    'p90': 'shoes',
    'p92': 'shoes',
    'p85': 'clothes',
    'p86': 'clothes',
    'p175': 'bags',
    'p176': 'bags',
    'p93': 'accessories',
    'p94': 'accessories',
    'p6': 'beauty',
    'p8': 'beauty',
  };

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/shoply_products.json',
    );

    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

    return (jsonData['products'] as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  ResponseProducts _parseProduct(Map<String, dynamic> product) {
    final data = Map<String, dynamic>.from(product);

    // Keep compatibility with the existing product model.
    data['image'] = data['images'];

    return ResponseProducts.fromJson(data);
  }

  Future<Either<String, List<ResponseProducts>>> getTrendingProducts() async {
    try {
      final products = await _loadProducts();

      final trendingProducts = products
          .where((product) => product['isTrending'] == true)
          .map(_parseProduct)
          .toList();

      return Right(trendingProducts);
    } catch (e) {
      return Left('Failed to load trending products: $e');
    }
  }

  Future<Either<String, List<ResponseProducts>>> getProducts({
    required String categoryId,
  }) async {
    try {
      final products = await _loadProducts();

      final categoryProducts = products
          .where(
            (product) =>
                _productCategories[product['id']?.toString()] == categoryId,
          )
          .map(_parseProduct)
          .toList();

      return Right(categoryProducts);
    } catch (e) {
      return Left('Failed to load products: $e');
    }
  }
}
