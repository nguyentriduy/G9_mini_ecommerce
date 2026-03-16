import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_selection.dart';
import '../utils/formatters.dart';
import 'network_product_image.dart';

class VariationBottomSheet extends StatefulWidget {
  const VariationBottomSheet({
    super.key,
    required this.product,
    required this.initialSelection,
    required this.confirmLabel,
  });

  final Product product;
  final ProductSelection initialSelection;
  final String confirmLabel;

  @override
  State<VariationBottomSheet> createState() => _VariationBottomSheetState();
}

class _VariationBottomSheetState extends State<VariationBottomSheet> {
  static const _sizes = ['S', 'M', 'L'];
  static const _colors = ['Đỏ', 'Xanh', 'Đen'];

  late ProductSelection _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6C2B5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: NetworkProductImage(
                    imageUrl: widget.product.imageUrl,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppFormatters.currency(widget.product.price),
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phân loại: ${_selection.size} / ${_selection.color}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Kích cỡ',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sizes.map((size) {
                return ChoiceChip(
                  label: Text(size),
                  selected: _selection.size == size,
                  onSelected: (_) => setState(
                    () => _selection = _selection.copyWith(size: size),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            const Text(
              'Màu sắc',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.map((color) {
                return ChoiceChip(
                  label: Text(color),
                  selected: _selection.color == color,
                  onSelected: (_) => setState(
                    () => _selection = _selection.copyWith(color: color),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text(
                  'Số lượng',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton.outlined(
                  onPressed: _selection.quantity > 1
                      ? () => setState(() {
                          _selection = _selection.copyWith(
                            quantity: _selection.quantity - 1,
                          );
                        })
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 34,
                  child: Text(
                    '${_selection.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton.filled(
                  onPressed: () => setState(() {
                    _selection = _selection.copyWith(
                      quantity: _selection.quantity + 1,
                    );
                  }),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_selection),
                child: Text(widget.confirmLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
