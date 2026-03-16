import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({required ProductService productService})
    : _productService = productService;

  final ProductService _productService;

  static const _pageSize = 10;
  static const List<String> _defaultCategories = [
    'Electronics',
    'Clothing',
    'Beauty',
    'Home',
    'Toys',
    'Shoes',
    'Sports',
    'Grocery',
  ];

  final List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';
  String? _error;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<String> get availableCategories {
    final categories = {
      ..._defaultCategories,
      ..._products.map((item) => item.category),
    };
    return ['Tất cả', ...categories.toList()..sort()];
  }

  List<Product> get displayedProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'Tất cả' ||
          product.category == _selectedCategory;
      final search = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          search.isEmpty ||
          product.name.toLowerCase().contains(search) ||
          product.category.toLowerCase().contains(search);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<String> get bannerImages {
    final images = _products
        .take(4)
        .map((product) => product.imageUrl)
        .toList();
    if (images.length >= 3) {
      return images;
    }
    return const [
      'https://picsum.photos/seed/banner1/1200/480',
      'https://picsum.photos/seed/banner2/1200/480',
      'https://picsum.photos/seed/banner3/1200/480',
      'https://picsum.photos/seed/banner4/1200/480',
    ];
  }

  Future<void> loadInitial() async {
    if (_products.isNotEmpty || _isLoading) {
      return;
    }
    await refresh();
  }

  Future<void> refresh() async {
    _isLoading = true;
    _error = null;
    _page = 1;
    _hasMore = true;
    notifyListeners();

    try {
      final items = await _productService.fetchProducts(
        page: _page,
        limit: _pageSize,
      );
      _products
        ..clear()
        ..addAll(items);
      _hasMore = items.length >= _pageSize;
      _page = 2;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoading || _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      final items = await _productService.fetchProducts(
        page: _page,
        limit: _pageSize,
      );
      if (items.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(
          items.where((item) => !_products.any((saved) => saved.id == item.id)),
        );
        _hasMore = items.length >= _pageSize;
        _page += 1;
      }
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void updateCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }
}
