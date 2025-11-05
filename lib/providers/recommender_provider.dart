import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

enum RecState { idle, loading, success, noData, error }

class RecommenderProvider with ChangeNotifier {
  final ApiService api = ApiService();
  RecState state = RecState.idle;
  List<Product> topProducts = [];
  Map<String, dynamic> topByCategory = {};
  String errorMessage = '';

  Future<void> fetchTopProducts({int limit = 20}) async {
    state = RecState.loading;
    notifyListeners();
    try {
      final res = await api.get(
        '/recommender/top-products',
        params: {'limit': '$limit'},
      );
      if (res['state'] == 'success') {
        final list = (res['data'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
        topProducts = list;
        state = RecState.success;
      } else {
        topProducts = [];
        state = RecState.noData;
      }
    } catch (e) {
      state = RecState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchTopByCategory({int limitPerCategory = 5}) async {
    state = RecState.loading;
    notifyListeners();
    try {
      final res = await api.get(
        '/recommender/top-by-category',
        params: {'limit': '$limitPerCategory'},
      );
      if (res['state'] == 'success') {
        topByCategory = {
          for (var r in res['data']) r['category_id'].toString(): r['products'],
        };
        state = RecState.success;
      } else {
        topByCategory = {};
        state = RecState.noData;
      }
    } catch (e) {
      state = RecState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
