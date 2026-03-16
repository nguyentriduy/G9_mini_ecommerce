import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../utils/formatters.dart';
import '../widgets/network_product_image.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, CartItem item) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa sản phẩm'),
            content: const Text(
              'Bạn có muốn xóa sản phẩm này khỏi giỏ hàng không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete && context.mounted) {
      await context.read<CartProvider>().removeItem(item.id);
    }
  }

  Future<bool> _confirmDismiss(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa sản phẩm'),
            content: const Text(
              'Bạn có muốn xóa sản phẩm này khỏi giỏ hàng không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleCheckout(
    BuildContext context,
    List<CartItem> items,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(items: items, clearCartOnSuccess: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: const Color(0xFFFFF7ED),
        foregroundColor: const Color(0xFF111827),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Giỏ hàng đang trống.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDismiss(context),
                onDismissed: (_) => cart.removeItem(item.id),
                background: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: item.isSelected,
                          onChanged: (value) =>
                              cart.toggleSelection(item.id, value),
                        ),
                        SizedBox(
                          width: 84,
                          height: 84,
                          child: NetworkProductImage(
                            imageUrl: item.product.imageUrl,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Phân loại: ${item.size} / ${item.color}',
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    AppFormatters.currency(item.product.price),
                                    style: const TextStyle(
                                      color: Color(0xFFDC2626),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton.outlined(
                                    onPressed: () async {
                                      if (item.quantity == 1) {
                                        await _confirmDelete(context, item);
                                        return;
                                      }
                                      await cart.decrementQuantity(item.id);
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  SizedBox(
                                    width: 28,
                                    child: Text(
                                      '${item.quantity}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  IconButton.filled(
                                    onPressed: () =>
                                        cart.incrementQuantity(item.id),
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: cart.items.length,
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 20,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: cart.isAllSelected,
                    onChanged: cart.items.isEmpty
                        ? null
                        : (value) => cart.toggleSelectAll(value),
                  ),
                  const Text(
                    'Chọn tất cả',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Tổng thanh toán',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        AppFormatters.currency(cart.selectedTotal),
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: cart.selectedItems.isEmpty
                        ? null
                        : () => _handleCheckout(context, cart.selectedItems),
                    child: Text('Mua hàng (${cart.selectedItems.length})'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
