import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:dartz/dartz.dart';
import 'package:shoply_app/core/model/categories/ressponse_categories.dart';

class CategoriesUsecase {
  Future<Either<String, List<RessponseCategories>>> getCategories() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/shoply_products.json',
      );

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      final List<dynamic> categoriesJson = jsonData['categories'] as List;

      final categoriesData = categoriesJson
          .map(
            (category) => RessponseCategories.fromJson(
              Map<String, dynamic>.from(category),
            ),
          )
          .toList();

      return Right(categoriesData);
    } catch (e) {
      return Left('Failed to load categories: $e');
    }
  }
}
