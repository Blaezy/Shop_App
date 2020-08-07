import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_Item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-Screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart Items'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.itemTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false)
                          .addOrder(cart.items.values.toList(), cart.itemTotal);
                      cart.clear();
                    },
                    child: Text(
                      "Order Now",
                    ),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) {
              return ci.CartItem(
                  cart.items.values.toList()[i].cartitemId,
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].quantity,
                  cart.items.keys.toList()[i]);
            },
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
