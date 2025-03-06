import 'package:flutter/foundation.dart';
import 'package:myshop/models/product.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';

class CartManager with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final CartService _cartService = CartService();

  CartManager() {
    _loadCartFromDatabase();
  }

  Future<void> _loadCartFromDatabase() async {
    final cartItems = await _cartService.getCartItems();
    _items.clear();
    for (var item in cartItems) {
      _items[item['id']] = CartItem(
        id: item['id'],
        title: item['title'],
        imageUrl: '',
        price: item['price'],
        quantity: item['quantity'],
      );
    }
    notifyListeners();
  }

  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._items}.entries;
  }

  double get totalAmount {
    return _items.values.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id!,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id!,
        () => CartItem(
          id: product.id!,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: 1,
        ),
      );
    }

    await _cartService.addToCart(product.id!, product.title, product.price, _items[product.id!]!.quantity);
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }

    // Cập nhật SQLite
    if (_items.containsKey(productId)) {
      await _cartService.addToCart(productId, _items[productId]!.title, _items[productId]!.price, _items[productId]!.quantity);
    } else {
      await _cartService.removeItem(productId);
    }

    notifyListeners();
  }

  Future<void> clearItem(String productId) async {
    _items.remove(productId);
    await _cartService.removeItem(productId);
    notifyListeners();
  }

  Future<void> clearAllItems() async {
    _items.clear();
    await _cartService.clearCart();
    notifyListeners();
  }
}
