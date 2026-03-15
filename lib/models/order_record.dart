import 'cart_item.dart';

class OrderStatus {
  static const pending = 'pending';
  static const shipping = 'shipping';
  static const delivered = 'delivered';
  static const cancelled = 'cancelled';

  static const labels = {
    pending: 'Chờ xác nhận',
    shipping: 'Đang giao',
    delivered: 'Đã giao',
    cancelled: 'Đã hủy',
  };
}

class OrderRecord {
  OrderRecord({
    required this.id,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
  });

  final String id;
  final List<CartItem> items;
  final String address;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final double totalAmount;

  factory OrderRecord.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return OrderRecord(
      id: (json['id'] ?? '').toString(),
      items: itemsJson.map(CartItem.fromJson).toList(),
      address: (json['address'] ?? '').toString(),
      paymentMethod: (json['paymentMethod'] ?? 'COD').toString(),
      status: (json['status'] ?? OrderStatus.pending).toString(),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'address': address,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }
}
