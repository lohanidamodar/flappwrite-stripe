import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  addProduct(Product product) {
    state = [...state, product];
  }

  removeProduct(String productId) {
    state = state.where((element) => element.id != productId).toList();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) => CartNotifier());
