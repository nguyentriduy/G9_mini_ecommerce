import 'package:flutter_test/flutter_test.dart';

import 'package:g9_mini_ecommerce/app.dart';

void main() {
  testWidgets('App renders product detail screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Chi tiết sản phẩm'), findsOneWidget);
    expect(find.text('Mô tả chi tiết'), findsOneWidget);
  });
}
