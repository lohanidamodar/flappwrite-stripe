import 'dart:convert';
import 'package:flappwrite_stripe/utils/config.dart' as config;

class Product {
  final String name;
  final String imageUrl;
  final double price;
  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  Product copyWith({
    String? name,
    String? imageUrl,
    double? price,
  }) {
    return Product(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '${config.endpoint}/avatars/initials?name=${map["name"]}',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() => 'Product(name: $name, imageUrl: $imageUrl, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Product &&
      other.name == name &&
      other.imageUrl == imageUrl &&
      other.price == price;
  }

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode ^ price.hashCode;
}
