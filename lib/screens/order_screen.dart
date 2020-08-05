import 'package:Shop_App/providers/orders.dart';
import 'package:Shop_App/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return OrderThings(orderData.orders[i]);
        },
        itemCount: orderData.orders.length,
      ),
      drawer: AppDrawer(),
    );
  }
}
