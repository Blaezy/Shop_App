import 'package:Shop_App/screens/edit_product_screen.dart';
import 'package:Shop_App/widgets/app_drawer.dart';

import '../widgets/user_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData(
        true); //Context is not available everywhere in stateless widgets so wee need to pass it as a parameter.
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _refreshProduct(context),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, i) {
                                return UserProduct(
                                  productsData.items[i].id,
                                  productsData.items[i].title,
                                  productsData.items[i].imageUrl,
                                );
                              }),
                        ),
                      ),
                    ),
        ));
  }
}
