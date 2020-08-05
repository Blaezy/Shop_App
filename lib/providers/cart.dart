import 'package:flutter/cupertino.dart';

class CartItem {
  String cartitemId;
  String title;
  double price;
  int quantity;

  CartItem({
    @required this.cartitemId,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get itemTotal {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void addItem(String title, String id, double price) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (value) => CartItem(
              cartitemId: value.cartitemId, //value is existing cartItem
              price: value.price,
              quantity: value.quantity + 1,
              title: value.title));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              cartitemId: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
