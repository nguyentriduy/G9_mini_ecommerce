import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../utils/formatters.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    this.items = const [],
    this.clearCartOnSuccess = true,
  });

  final List<CartItem> items;
  final bool clearCartOnSuccess;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  String _paymentMethod = 'COD';
  bool _submitting = false;

  double get _totalAmount {
    return widget.items.fold(0.0, (total, item) => total + item.subtotal);
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ nhận hàng.')),
      );
      return;
    }

    setState(() => _submitting = true);
    await context.read<OrderProvider>().addOrder(
      items: widget.items,
      address: _addressController.text.trim(),
      paymentMethod: _paymentMethod,
    );

    if (widget.clearCartOnSuccess && mounted) {
      await context.read<CartProvider>().removeItemsByIds(
        widget.items.map((item) => item.id).toList(),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() => _submitting = false);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đặt hàng thành công'),
        content: const Text(
          'Đơn hàng đã được ghi nhận và chuyển về trang chủ.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: const Color(0xFFFFF7ED),
        foregroundColor: const Color(0xFF111827),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Địa chỉ nhận hàng',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: ['COD', 'Momo'].map((method) {
                        return ChoiceChip(
                          label: Text(method),
                          selected: _paymentMethod == method,
                          onSelected: (_) =>
                              setState(() => _paymentMethod = method),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sản phẩm thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...widget.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Phân loại: ${item.size} / ${item.color} • SL: ${item.quantity}',
                    ),
                    trailing: Text(
                      AppFormatters.currency(item.subtotal),
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tổng cộng',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                  ),
                  Text(
                    AppFormatters.currency(_totalAmount),
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: _submitting ? null : _submitOrder,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Đặt hàng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
