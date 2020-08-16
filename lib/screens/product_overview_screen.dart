import 'package:Shop_App/providers/products.dart';
import 'package:Shop_App/widgets/app_drawer.dart';

import '../screens/cart_screen.dart';

import '../providers/cart.dart';
import '../widgets/badge.dart';
import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favourites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavourites = false;
  var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetData().then((value) {
        setState(() {
          isLoading = false;
        }); //async and await functionality will not work here then is the only option
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions filter) {
                setState(() {
                  if (filter == FilterOptions.Favourites)
                    showFavourites = true;
                  else
                    showFavourites = false;
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(showFavourites),
    );
  }
}
