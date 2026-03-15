import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({
    super.key,
    required this.onPressed,
    this.color = Colors.white,
  });

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return IconButton(
          onPressed: onPressed,
          icon: Badge.count(
            isLabelVisible: cart.itemTypeCount > 0,
            count: cart.itemTypeCount,
            backgroundColor: const Color(0xFFDC2626),
            child: Icon(Icons.shopping_cart_outlined, color: color),
          ),
        );
      },
    );
  }
}
