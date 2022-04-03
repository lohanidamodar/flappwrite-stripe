import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../widgets/cart_item.dart';
import '../widgets/empty_cart.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Product> products = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: products.isEmpty
          ? const Center(child: EmptyCart())
          : ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) => CartItem(products[index]),
            ),
    );
  }
}
