import 'package:flappwrite_stripe/models/cart_product.dart';
import 'package:flappwrite_stripe/models/product.dart';
import 'package:flappwrite_stripe/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem extends ConsumerWidget {
  const CartItem(this.item, {Key? key}) : super(key: key);

  final CartProduct item;

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
                item.product.imageUrl,
                height: 100,
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(item.product.name),
              subtitle: Text("\$${item.product.price}"),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .removeProduct(item.product.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Product removed from the cart.")));
                },
                icon: const Icon(Icons.clear),
              ),
              const SizedBox(height: 20.0),
              CartItemCounter(
                count: item.count,
                onIncrement: () {
                  ref.read(cartProvider.notifier).addProduct(item.product);
                },
                onDecrement: item.count > 1
                    ? () {
                        ref
                            .read(cartProvider.notifier)
                            .reduceProductCount(item.product.id);
                      }
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CartItemCounter extends StatelessWidget {
  const CartItemCounter(
      {Key? key, required this.count, this.onDecrement, this.onIncrement})
      : super(key: key);
  final int count;
  final Function()? onIncrement;
  final Function()? onDecrement;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: onDecrement,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade200),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.remove,
                color: Colors.grey.shade800,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$count'),
        ),
        const SizedBox(width: 4),
        InkWell(
          onTap: onIncrement,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade200),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.add,
                color: Colors.grey.shade800,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0)
      ],
    );
  }
}
