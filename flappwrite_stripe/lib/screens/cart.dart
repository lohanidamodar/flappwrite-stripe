import 'package:flappwrite_stripe/models/cart_product.dart';
import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flappwrite_stripe/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/cart_item.dart';
import '../widgets/empty_cart.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CartProduct> products = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: products.isEmpty
          ? const Center(child: EmptyCart())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) => CartItem(products[index]),
                  ),
                ),
                ListTile(
                  title: const Text("Total"),
                  trailing: Text(
                    "\$$total",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.titleTextColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'checkout');
                    },
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
    );
  }
}
