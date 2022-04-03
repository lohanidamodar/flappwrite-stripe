import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.shopping_cart,
          size: 50,
        ),
        SizedBox(height: 20.0),
        Text("Add some products to your cart."),
      ],
    );
  }
}
