import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_product.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartProduct>> {
  CartNotifier() : super([]);

  bool _hasProduct(Product product) {
    return state.where((item) => item.product.id == product.id).isNotEmpty;
  }

  addProduct(Product product) {
    if (_hasProduct(product)) {
      state = [
        ...state.map(
          (item) {
            if (item.product.id == product.id) {
              return item.copyWith(count: item.count + 1);
            }
            return item;
          },
        )
      ];
    } else {
      state = [...state, CartProduct(product: product, count: 1)];
    }
  }

  reduceProductCount(String productId) {
    state = [
      ...state.map((item) {
        if (item.product.id == productId) {
          return item.copyWith(count: item.count - 1);
        }
        return item;
      })
    ];
  }

  removeProduct(String productId) {
    state = state.where((element) => element.product.id != productId).toList();
  }

  emptyCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartProduct>>(
    (ref) => CartNotifier());

final cartTotalProvider = StateProvider<double>((ref) {
  double total = 0.0;
  final products = ref.watch(cartProvider);
  for (var product in products) {
    total += product.count * product.product.price;
  }
  return total;
});
