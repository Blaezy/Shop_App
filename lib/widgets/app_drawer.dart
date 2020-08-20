import 'package:Shop_App/providers/auth.dart';
import 'package:Shop_App/screens/order_screen.dart';
import 'package:Shop_App/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushNamed('/');
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routName);
                // Navigator.of(context).pushReplacement(CustomRoute(builder: ))
              }),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('User Products'),
              onTap: () {
                Navigator.of(context).pushNamed(UserProductScreen.routeName);
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                // Navigator.of(context).pushNamed(UserProductScreen.routeName);
                Provider.of<Auth>(context, listen: false).logout();
              })
        ],
      ),
    );
  }
}
