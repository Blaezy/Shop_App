import 'package:Shop_App/providers/auth.dart';
import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/orders.dart';
import 'package:Shop_App/providers/products.dart';
import 'package:Shop_App/screens/auth_screen.dart';
import 'package:Shop_App/screens/cart_screen.dart';
import 'package:Shop_App/screens/edit_product_screen.dart';
import 'package:Shop_App/screens/order_screen.dart';
import 'package:Shop_App/screens/product_detail_screen.dart';
import 'package:Shop_App/screens/product_overview_screen.dart';
import 'package:Shop_App/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, authData, previousproducts) => Products(
                authData.token,
                authData.userId,
                previousproducts == null ? [] : previousproducts.items),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Colors.orange,
                fontFamily: 'Lato'),
            home: authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
