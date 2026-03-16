import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_record.dart';
import '../providers/order_provider.dart';
import '../utils/formatters.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const statuses = [
      OrderStatus.pending,
      OrderStatus.shipping,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];

    return DefaultTabController(
      length: statuses.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn mua'),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF111827),
          bottom: TabBar(
            isScrollable: true,
            tabs: statuses
                .map((status) => Tab(text: OrderStatus.labels[status]))
                .toList(),
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orders, child) {
            return TabBarView(
              children: statuses.map((status) {
                final items = orders.ordersByStatus(status);
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có đơn ở trạng thái ${OrderStatus.labels[status]}.',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final order = items[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Mã đơn #${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  OrderStatus.labels[order.status] ??
                                      order.status,
                                  style: const TextStyle(
                                    color: Color(0xFFEA580C),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(AppFormatters.orderDate(order.createdAt)),
                            const SizedBox(height: 8),
                            Text('Giao đến: ${order.address}'),
                            const SizedBox(height: 8),
                            Text('Thanh toán: ${order.paymentMethod}'),
                            const Divider(height: 24),
                            ...order.items.take(2).map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '• ${item.product.name} (${item.size}/${item.color}) x${item.quantity}',
                                ),
                              );
                            }),
                            if (order.items.length > 2)
                              Text('+ ${order.items.length - 2} sản phẩm khác'),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Tổng: ${AppFormatters.currency(order.totalAmount)}',
                                style: const TextStyle(
                                  color: Color(0xFFDC2626),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: items.length,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
