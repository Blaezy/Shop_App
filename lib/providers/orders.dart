import 'dart:convert';

import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shopapp-e8259.firebaseio.com/orders.json';
    //try{
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>)
              .map((e) => CartItem(
                  cartitemId: e['cartitemId'],
                  price: e['price'],
                  quantity: e['quantity'],
                  title: e['title']))
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
    //  }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shopapp-e8259.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'total': total,
          'date': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'cartitemId': e.cartitemId,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList()
        }));

    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          total: total,
          date: timeStamp,
          products: cartProducts),
    );
    notifyListeners();
  }
}
