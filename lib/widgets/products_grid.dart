import '../providers/products.dart';
import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  /*const ProductsGrid({
    Key key,
    @required this.loadedProducts,
  }) : super(key: key);

  final List<Product> loadedProducts;*/ //we dont want any constructor like this bcoz we want to fetch data by setting some listeners.

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(
        context); //this set up a direct communication channel between provider classes and widgets
    final products = productsData.items;
    return GridView.builder(
        itemBuilder: (ctx, i) => ChangeNotifierProvider(
              create: (c) => products[i],
              child: ProductItem(
                  // products[i].id, products[i].title, products[i].imageUrl
                  ),
            ),
        itemCount: products.length,
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10));
  }
}
