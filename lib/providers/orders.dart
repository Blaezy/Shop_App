import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final DateTime date;
  final double total;
  final List<CartItem> products;

  OrderItem(
      {@required this.id,
      @required this.date,
      @required this.total,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          total: total,
          date: DateTime.now(),
          products: cartItems),
    );
    notifyListeners();
  }
}
