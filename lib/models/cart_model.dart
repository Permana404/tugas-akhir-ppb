import 'product_model.dart';

class CartItem {
  final Product product; // <-- Diubah menjadi Product
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal {
    double price = double.tryParse(product.price.toString()) ?? 0.0;
    return price * quantity;
  }
}
