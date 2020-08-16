import 'dart:convert';
import 'dart:io';

import 'product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
//we dont wnat to let other widget directly access/modify the list of products.Hence we added a getter to reflect the changes.
  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get showFavourites {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> updateProduct(String id, Product newpro) async {
    final index = _items.lastIndexWhere(
        (pro) => pro.id == id); //returns index of the product to be edited
    if (index >= 0) {
      final url = 'https://shopapp-e8259.firebaseio.com/Products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newpro.title,
            'description': newpro.description,
            'price': newpro.price,
            'imageUrl': newpro.imageUrl,
          }));
      _items[index] = newpro;
      notifyListeners();
    }
  }

  Future<void> fetchAndSetData() async {
    const url = 'https://shopapp-e8259.firebaseio.com/Products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodID, prodData) {
        loadedProduct.add(Product(
            id: prodID,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavourite: prodData['isFavourite']));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product newPro) async {
    const url = 'https://shopapp-e8259.firebaseio.com/Products.json';
    try {
      final value = await http.post(
        url,
        body: json.encode(
          {
            'title': newPro.title,
            'imageUrl': newPro.imageUrl,
            'description': newPro.description,
            'price': newPro.price,
            'isFavourite': newPro.isFavourite
          },
        ),
      );
      final newProduct = Product(
          id: json.decode(value.body)['name'],
          title: newPro.title,
          description: newPro.description,
          imageUrl: newPro.imageUrl,
          price: newPro.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shopapp-e8259.firebaseio.com/Products/$id.json';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final value = await http.delete(url);
    if (value.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not Delete Productt');
    }
    existingProduct = null;
  }
}
