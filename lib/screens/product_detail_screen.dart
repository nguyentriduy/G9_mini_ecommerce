import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/product_selection.dart';
import '../providers/cart_provider.dart';
import '../utils/formatters.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/expandable_text.dart';
import '../widgets/network_product_image.dart';
import '../widgets/variation_bottom_sheet.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;
  ProductSelection _selection = ProductSelection.initial();

  Future<void> _showSelectionSheet({
    required String confirmLabel,
    required bool addToCart,
    required bool buyNow,
  }) async {
    final selection = await showModalBottomSheet<ProductSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => VariationBottomSheet(
        product: widget.product,
        initialSelection: _selection,
        confirmLabel: confirmLabel,
      ),
    );

    if (selection == null || !mounted) {
      return;
    }

    setState(() => _selection = selection);

    if (addToCart) {
      await context.read<CartProvider>().addProduct(widget.product, selection);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Thêm thành công')));
      return;
    }

    if (buyNow) {
      final item = CartItem.fromSelection(
        product: widget.product,
        selection: selection,
      );
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              CheckoutScreen(items: [item], clearCartOnSuccess: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        foregroundColor: const Color(0xFF111827),
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
          CartBadgeButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
            },
            color: const Color(0xFF111827),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE6D5C9)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CartScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF3E7), Color(0xFFFFE0C2)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: OutlinedButton(
                    onPressed: () => _showSelectionSheet(
                      confirmLabel: 'Xác nhận',
                      addToCart: true,
                      buyNow: false,
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: BorderSide.none,
                    ),
                    child: const Text('Thêm vào giỏ hàng'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: FilledButton(
                  onPressed: () => _showSelectionSheet(
                    confirmLabel: 'Mua ngay',
                    addToCart: false,
                    buyNow: true,
                  ),
                  child: const Text('Mua ngay'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Stack(
            children: [
              CarouselSlider.builder(
                itemCount: product.galleryUrls.length,
                itemBuilder: (context, index, realIndex) {
                  final child = NetworkProductImage(
                    imageUrl: product.galleryUrls[index],
                    fit: BoxFit.cover,
                  );
                  if (index == 0) {
                    return Hero(tag: 'product-${product.id}', child: child);
                  }
                  return child;
                },
                options: CarouselOptions(
                  height: 360,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) =>
                      setState(() => _imageIndex = index),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(product.galleryUrls.length, (index) {
                    final selected = index == _imageIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: selected ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white
                            : const Color(0x66FFFFFF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppFormatters.currency(product.price),
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppFormatters.currency(product.originalPrice),
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        product.highlightTag,
                        style: const TextStyle(
                          color: Color(0xFFE11D48),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppFormatters.soldCount(product.sold),
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    const Spacer(),
                    if (product.discountPercent > 0)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Giảm ${product.discountPercent}%',
                          style: const TextStyle(
                            color: Color(0xFF92400E),
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Card(
                  child: ListTile(
                    onTap: () => _showSelectionSheet(
                      confirmLabel: 'Xác nhận',
                      addToCart: false,
                      buyNow: false,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    title: const Text(
                      'Chọn Kích cỡ, Màu sắc',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Đã chọn: ${_selection.size} / ${_selection.color}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEDD5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right_rounded, size: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Mô tả chi tiết',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ExpandableText(text: product.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
