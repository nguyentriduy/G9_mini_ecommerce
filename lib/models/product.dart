class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.sold,
    required this.tag,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final String category;
  final int sold;
  final String tag;
  final DateTime createdAt;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? '').toString(),
      name: _cleanText(json['name']) ?? 'Sản phẩm mới',
      description: _cleanText(json['description']) ?? 'Đang cập nhật mô tả.',
      imageUrl: _normalizeImageUrl(
        rawValue: json['image'],
        seed: (json['id'] ?? 'product').toString(),
      ),
      price: _toDouble(json['price']),
      originalPrice: _toDouble(json['originalPrice']),
      category: _cleanText(json['category']) ?? 'Khác',
      sold: _toInt(json['sold']),
      tag: _cleanText(json['tag']) ?? '',
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'sold': sold,
      'tag': tag,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  List<String> get galleryUrls {
    return {
      imageUrl,
      'https://picsum.photos/seed/${id}a/900/900',
      'https://picsum.photos/seed/${id}b/900/900',
    }.toList();
  }

  int get discountPercent {
    if (originalPrice <= price || originalPrice <= 0) {
      return 0;
    }
    final discount = ((originalPrice - price) / originalPrice) * 100;
    return discount.round();
  }

  String get highlightTag {
    if (sold >= 80) {
      return 'Mall';
    }
    if (discountPercent >= 40) {
      return 'Giảm $discountPercent%';
    }
    return 'Yêu thích';
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse((value ?? '').toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse((value ?? '').toString()) ?? 0;
  }

  static String? _cleanText(dynamic value) {
    final text = (value ?? '')
        .toString()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (text.isEmpty) {
      return null;
    }
    return text;
  }

  static String _normalizeImageUrl({
    required dynamic rawValue,
    required String seed,
  }) {
    final fallback = 'https://picsum.photos/seed/$seed/800/800';
    var value = (rawValue ?? '')
        .toString()
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
    if (value.isEmpty) {
      return fallback;
    }

    const replacements = {
      'ttps://': 'https://',
      'ttps:/': 'https://',
      'https:/': 'https://',
      'http:/': 'http://',
      'https//': 'https://',
      'http//': 'http://',
      ':/': '://',
    };

    replacements.forEach((key, replacement) {
      if (value.startsWith(key)) {
        value = value.replaceFirst(key, replacement);
      }
    });

    if (value.startsWith('//')) {
      value = 'https:$value';
    }

    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      value = 'https://$value';
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || (uri.host).trim().isEmpty) {
      return fallback;
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return fallback;
    }

    // loremflickr hay trả ảnh lỗi/timeout trên mobile, ưu tiên nguồn fallback ổn định.
    if (uri.host.contains('loremflickr.com')) {
      return fallback;
    }

    if (!uri.host.contains('.')) {
      return fallback;
    }

    return uri.toString();
  }
}
