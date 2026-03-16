import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'services/product_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

// final Product _demoProduct = Product(
//   id: 'demo-1',
//   name: 'Áo khoác unisex basic',
//   description:
//       'Chất liệu dày dặn, form rộng dễ phối đồ. Phù hợp đi học, đi làm, đi chơi. Đường may chắc chắn, mặc thoải mái cả ngày.',
//   imageUrl: 'https://picsum.photos/seed/demo-product/900/900',
//   price: 349000,
//   originalPrice: 499000,
//   category: 'Thời trang',
//   sold: 128,
//   tag: 'Bán chạy',
//   createdAt: DateTime(2026, 1, 1),
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            productService: ProductService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mini E-commerce',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
