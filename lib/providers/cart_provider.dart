import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/product_selection.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  CartProvider() {
    _hydrate();
  }

  final List<CartItem> _items = [];
  bool _isHydrated = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isHydrated => _isHydrated;
  int get itemTypeCount => _items.length;
  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);
  List<CartItem> get selectedItems =>
      _items.where((item) => item.isSelected).toList();

  double get selectedTotal {
    return _items
        .where((item) => item.isSelected)
        .fold(0, (total, item) => total + item.subtotal);
  }

  Future<void> _hydrate() async {
    final savedItems = await StorageService.loadCartItems();
    _items
      ..clear()
      ..addAll(savedItems.map(CartItem.fromJson));
    _isHydrated = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    await StorageService.saveCartItems(
      _items.map((item) => item.toJson()).toList(),
    );
  }

  Future<void> addProduct(Product product, ProductSelection selection) async {
    final item = CartItem.fromSelection(product: product, selection: selection);
    final index = _items.indexWhere((savedItem) => savedItem.id == item.id);

    if (index >= 0) {
      final current = _items[index];
      _items[index] = current.copyWith(
        quantity: current.quantity + item.quantity,
        isSelected: true,
      );
    } else {
      _items.add(item);
    }

    notifyListeners();
    await _persist();
  }

  Future<void> toggleSelection(String id, bool? isSelected) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0) {
      return;
    }

    _items[index] = _items[index].copyWith(isSelected: isSelected ?? false);
    notifyListeners();
    await _persist();
  }

  Future<void> toggleSelectAll(bool? isSelected) async {
    final newValue = isSelected ?? false;
    for (var index = 0; index < _items.length; index++) {
      _items[index] = _items[index].copyWith(isSelected: newValue);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> incrementQuantity(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0) {
      return;
    }
    _items[index] = _items[index].copyWith(
      quantity: _items[index].quantity + 1,
    );
    notifyListeners();
    await _persist();
  }

  Future<void> decrementQuantity(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0 || _items[index].quantity <= 1) {
      return;
    }
    _items[index] = _items[index].copyWith(
      quantity: _items[index].quantity - 1,
    );
    notifyListeners();
    await _persist();
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> removeItemsByIds(List<String> ids) async {
    _items.removeWhere((item) => ids.contains(item.id));
    notifyListeners();
    await _persist();
  }
}
