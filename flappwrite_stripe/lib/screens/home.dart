import 'package:appwrite/models.dart';
import 'package:flappwrite_stripe/models/product.dart';
import 'package:flutter/material.dart';
import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';

import '../widgets/product_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appwrite Store'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.authNotifier.deleteSession();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'cart');
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: FutureBuilder<DocumentList>(
          future: Database(context.authNotifier.client)
              .listDocuments(collectionId: 'products'),
          builder: (context, snapshot) {
            if (snapshot.data == null) return const CircularProgressIndicator();
            final docs = snapshot.data!.convertTo((product) =>
                Product.fromMap(Map<String, dynamic>.from(product)));
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              itemCount: docs.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) => ProductItem(docs[index]),
            );
          }),
    );
  }
}
