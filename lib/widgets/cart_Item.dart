import 'package:Shop_App/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;

  CartItem(this.id, this.title, this.price, this.quantity, this.productId);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you Sure?'),
                content: Text('Item will be removed from the cart'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('Yes'))
                ],
              );
            });
      },
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: FittedBox(child: Text('\$$price')),
              ),
              title: Text(title),
              subtitle: Text('Total Amount ${(price * quantity)}'),
              trailing: Text('$quantity x'),
            )),
      ),
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
    );
  }
}
