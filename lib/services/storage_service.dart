import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _cartKey = 'cart_items';
  static const _ordersKey = 'order_items';

  static Future<List<Map<String, dynamic>>> loadCartItems() async {
    return _loadList(_cartKey);
  }

  static Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    await _saveList(_cartKey, items);
  }

  static Future<List<Map<String, dynamic>>> loadOrders() async {
    return _loadList(_ordersKey);
  }

  static Future<void> saveOrders(List<Map<String, dynamic>> items) async {
    await _saveList(_ordersKey, items);
  }

  static Future<List<Map<String, dynamic>>> _loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return <Map<String, dynamic>>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static Future<void> _saveList(
    String key,
    List<Map<String, dynamic>> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(items));
  }
}
