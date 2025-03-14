import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'orders_manager.dart';
import 'order_item_card.dart';

import '../shared/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<OrdersManager>(
        builder: (ctx, ordersManager, chil) {
          return ListView.builder(
            itemCount: ordersManager.orderCount,
            itemBuilder: (ctx, i) => OrderItemCard(ordersManager.orders[i]),
          );
        }
      ),
    );
  }
}