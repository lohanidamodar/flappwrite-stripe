import 'dart:convert';

import 'package:flappwrite_stripe/utils/config.dart' as config;

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String id;
  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.id,
  });

  Product copyWith({
    String? name,
    String? imageUrl,
    double? price,
    String? id,
  }) {
    return Product(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      '\$id': id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ??
          '${config.endpoint}/avatars/initials?name=${map["name"]}',
      price: map['price']?.toDouble() ?? 0.0,
      id: map['\$id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(name: $name, imageUrl: $imageUrl, price: $price, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.price == price &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^ imageUrl.hashCode ^ price.hashCode ^ id.hashCode;
  }
}
