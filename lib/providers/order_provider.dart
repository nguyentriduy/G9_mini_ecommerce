import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order_record.dart';
import '../services/storage_service.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider() {
    _hydrate();
  }

  final List<OrderRecord> _orders = [];

  List<OrderRecord> get orders => List.unmodifiable(_orders);

  Future<void> _hydrate() async {
    final savedItems = await StorageService.loadOrders();
    _orders
      ..clear()
      ..addAll(savedItems.map(OrderRecord.fromJson));
    notifyListeners();
  }

  Future<void> _persist() async {
    await StorageService.saveOrders(
      _orders.map((item) => item.toJson()).toList(),
    );
  }

  List<OrderRecord> ordersByStatus(String status) {
    return _orders.where((item) => item.status == status).toList();
  }

  Future<void> addOrder({
    required List<CartItem> items,
    required String address,
    required String paymentMethod,
  }) async {
    final totalAmount = items.fold(0.0, (sum, item) => sum + item.subtotal);
    _orders.insert(
      0,
      OrderRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: items,
        address: address,
        paymentMethod: paymentMethod,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        totalAmount: totalAmount,
      ),
    );
    notifyListeners();
    await _persist();
  }
}
