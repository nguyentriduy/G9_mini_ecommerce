import 'package:intl/intl.dart';

class AppFormatters {
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: 0,
  );

  static String currency(double value) {
    return '${_currencyFormatter.format(value).trim()}đ';
  }

  static String soldCount(int value) {
    if (value >= 1000) {
      return 'Đã bán ${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    }
    return 'Đã bán $value';
  }

  static String orderDate(DateTime value) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(value);
  }
}
