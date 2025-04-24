import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Product> _localProducts = [];

  List<CartItem> get items => List.unmodifiable(_items);
  List<Product> get localProducts => List.unmodifiable(_localProducts);

  double get total => _items.fold(0, (sum, item) => sum + item.total);

  void addItem(Product product) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    if (_items.contains(existingItem)) {
      existingItem.quantity++;
    } else {
      _items.add(existingItem);
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    if (quantity <= 0) {
      _items.remove(item);
    } else {
      item.quantity = quantity;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Local product management
  void addLocalProduct(Product product) {
    _localProducts.add(product);
    notifyListeners();
  }

  void updateLocalProduct(Product product) {
    final index = _localProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _localProducts[index] = product;
      notifyListeners();
    }
  }

  void deleteLocalProduct(int id) {
    _localProducts.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
