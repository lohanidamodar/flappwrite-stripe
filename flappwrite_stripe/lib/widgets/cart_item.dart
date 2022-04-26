import 'package:flappwrite_stripe/models/product.dart';
import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem extends ConsumerWidget {
  const CartItem(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                product.imageUrl,
                height: 100,
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(product.name),
              subtitle: Text("\$${product.price}"),
              trailing: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  ref.watch(cartProvider.notifier).removeProduct(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Product removed from the cart.")));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
