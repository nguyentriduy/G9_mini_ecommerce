class ProductSelection {
  const ProductSelection({
    required this.size,
    required this.color,
    required this.quantity,
  });

  final String size;
  final String color;
  final int quantity;

  factory ProductSelection.initial() {
    return const ProductSelection(size: 'M', color: 'Đỏ', quantity: 1);
  }

  ProductSelection copyWith({String? size, String? color, int? quantity}) {
    return ProductSelection(
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }
}
