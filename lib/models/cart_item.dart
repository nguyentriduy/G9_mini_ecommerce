import 'product.dart';
import 'product_selection.dart';

class CartItem {
  CartItem({
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
    required this.isSelected,
  });

  final Product product;
  final String size;
  final String color;
  final int quantity;
  final bool isSelected;

  factory CartItem.fromSelection({
    required Product product,
    required ProductSelection selection,
  }) {
    return CartItem(
      product: product,
      size: selection.size,
      color: selection.color,
      quantity: selection.quantity,
      isSelected: true,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(
        Map<String, dynamic>.from(json['product'] as Map),
      ),
      size: (json['size'] ?? 'M').toString(),
      color: (json['color'] ?? 'Đỏ').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      isSelected: json['isSelected'] as bool? ?? true,
    );
  }

  String get id => '${product.id}|$size|$color';

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'size': size,
      'color': color,
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  CartItem copyWith({
    Product? product,
    String? size,
    String? color,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      product: product ?? this.product,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
