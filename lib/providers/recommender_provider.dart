import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

enum RecState { idle, loading, success, noData, error }

class RecommenderProvider with ChangeNotifier {
  final ApiService api = ApiService();
  RecState state = RecState.idle;
  List<Product> topProducts = [];
  List<dynamic> topVendors = [];
  List<dynamic> trending = [];
  List<dynamic> monthlyTop = [];
  Map<String, dynamic> topByCategory = {};
  String errorMessage = '';

  Future<void> _startLoading() async {
    state = RecState.loading;
    notifyListeners();
  }

  Map<String, String> _buildParams({
    int? limit,
    String? q,
    String? from,
    String? to,
    int? categoryId,
    int? vendorId,
  }) {
    final params = <String, String>{};
    if (limit != null) params['limit'] = limit.toString();
    if (q != null && q.isNotEmpty) params['q'] = q;
    if (from != null) params['from'] = from;
    if (to != null) params['to'] = to;
    if (categoryId != null) params['categoryId'] = categoryId.toString();
    if (vendorId != null) params['vendorId'] = vendorId.toString();
    return params;
  }

  Future<void> fetchTopProducts({
    int limit = 20,
    String? q,
    String? from,
    String? to,
    int? categoryId,
    int? vendorId,
  }) async {
    await _startLoading();
    try {
      final params = _buildParams(
        limit: limit,
        q: q,
        from: from,
        to: to,
        categoryId: categoryId,
        vendorId: vendorId,
      );
      final res = await api.get('/recommender/top-products', params: params);
      if (res['state'] == 'success') {
        topProducts = (res['data'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
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

  Future<void> fetchTopVendors({
    int limit = 20,
    String? q,
    String? from,
    String? to,
  }) async {
    await _startLoading();
    try {
      final params = _buildParams(limit: limit, q: q, from: from, to: to);
      final res = await api.get('/recommender/top-vendors', params: params);
      if (res['state'] == 'success') {
        topVendors = res['data'] as List;
        state = RecState.success;
      } else {
        topVendors = [];
        state = RecState.noData;
      }
    } catch (e) {
      state = RecState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchTrending7({
    int limit = 20,
    String? q,
    String? from,
    String? to,
  }) async {
    await _startLoading();
    try {
      final params = _buildParams(limit: limit, q: q, from: from, to: to);
      final res = await api.get('/recommender/trending-7d', params: params);
      if (res['state'] == 'success') {
        trending = res['data'] as List;
        state = RecState.success;
      } else {
        trending = [];
        state = RecState.noData;
      }
    } catch (e) {
      state = RecState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchMonthlyTop({
    int limit = 20,
    String? q,
    String? from,
    String? to,
  }) async {
    await _startLoading();
    try {
      final params = _buildParams(limit: limit, q: q, from: from, to: to);
      final res = await api.get('/recommender/monthly-top', params: params);
      if (res['state'] == 'success') {
        monthlyTop = res['data'] as List;
        state = RecState.success;
      } else {
        monthlyTop = [];
        state = RecState.noData;
      }
    } catch (e) {
      state = RecState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchTopByCategory({
    int limitPerCategory = 5,
    String? q,
    String? from,
    String? to,
  }) async {
    await _startLoading();
    try {
      final params = _buildParams(
        limit: limitPerCategory,
        q: q,
        from: from,
        to: to,
      );
      final res = await api.get('/recommender/top-by-category', params: params);
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
