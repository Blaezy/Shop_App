import 'package:Shop_App/providers/cart.dart';
import 'package:Shop_App/providers/product.dart';
import 'package:Shop_App/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  //final String title;
  //final String imageUrl;

  //ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: product.isFavourite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  product.toggleFavourite();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.title, product.id, product.price);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added Item to the Cart'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () => cart.removeSingleItem(product.id)),
                    ),
                  );
                },
                color: Theme.of(context).accentColor),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
