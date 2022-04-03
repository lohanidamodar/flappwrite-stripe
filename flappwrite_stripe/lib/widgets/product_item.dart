import 'package:flappwrite_stripe/models/product.dart';
import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductItem extends ConsumerWidget {
  const ProductItem(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text("\$${product.price}"),
      leading: Image.network(product.imageUrl),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        onPressed: () {
          ref.watch(cartProvider.notifier).addProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Product add to the cart.")));
        },
      ),
    );
  }
}
