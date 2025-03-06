import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';
import '../../models/order_item.dart';
import '../../services/order_service.dart';


class OrdersManager with ChangeNotifier {
  final List<OrderItem> _orders = [];
  final OrderService _orderService = OrderService();

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final newOrder = OrderItem(
      id: 'o${DateTime.now().toIso8601String()}',
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    notifyListeners();

    final items = cartProducts.map((cartItem) => {
      "id": cartItem.id,
      "title": cartItem.title,
      "price": cartItem.price,
      "quantity": cartItem.quantity,
      "imageUrl": cartItem.imageUrl,
    }).toList();

    await _orderService.placeOrder(items, total);
  }
}
