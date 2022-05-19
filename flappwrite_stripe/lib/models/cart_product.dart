import 'package:flappwrite_stripe/models/product.dart';

class CartProduct {
  final Product product;
  final int count;
  CartProduct({
    required this.product,
    required this.count,
  });

  CartProduct copyWith({
    Product? product,
    int? count,
  }) {
    return CartProduct(
      product: product ?? this.product,
      count: count ?? this.count,
    );
  }

  @override
  String toString() => 'CartProduct(product: $product, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CartProduct &&
      other.product == product &&
      other.count == count;
  }

  @override
  int get hashCode => product.hashCode ^ count.hashCode;
}
