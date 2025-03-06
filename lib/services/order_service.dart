import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../services/pocketbase_client.dart';
import '../models/order_item.dart';
import '../models/cart_item.dart';

class OrderService {
  final PocketBase pb = PocketBase(dotenv.env['POCKETBASE_URL']!);

  Future<OrderItem?> placeOrder(List<Map<String, dynamic>> items, double totalPrice) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      
      final record = await pb.collection('orders').create(
        body: {
          "user_id": userId,
          "items": jsonEncode(items),
          "status": "pending",
          "totalPrice": totalPrice,
          "createdAt": DateTime.now().toIso8601String(),
        },
      );

      // Decode the items from the record and map to CartItem
      List<CartItem> products = (jsonDecode(record.data['items']) as List).map((itemData) {
        return CartItem(
          id: itemData['id'],
          title: itemData['title'],
          price: itemData['price'],
          quantity: itemData['quantity'],
          imageUrl: itemData['imageUrl'],
        );
      }).toList();

      // Return the OrderItem object
      return OrderItem(
        id: record.id,
        amount: record.data['totalPrice'],
        products: products,
        dateTime: DateTime.parse(record.data['createdAt']),
      );
    } catch (e) {
      return null;
    }
  }
}
