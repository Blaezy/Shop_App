import 'package:Shop_App/providers/product.dart';
import 'package:Shop_App/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlfocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0);
  var initValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var isInit = true;
  @override
  void initState() {
    _imageUrlfocus.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final idfoundout = ModalRoute.of(context).settings.arguments as String;
      if (idfoundout != null) {
        editedProduct =
            Provider.of<Products>(context, listen: false).findById(idfoundout);
        initValue = {
          'title': editedProduct.title,
          'price': editedProduct.price.toString(),
          'description': editedProduct.description,
          //'imageUrl': newVariable.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = editedProduct.imageUrl;
      }
    }

    isInit = false;
    super.didChangeDependencies();
  }

  void updateImageUrl() {
    if (!_imageUrlfocus.hasFocus) {
      if ((!_imageUrlController.text.startsWith('https') &&
              !_imageUrlController.text.startsWith('http')) ||
          ((!_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('.jpg')))) return;

      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final validate = _formKey.currentState.validate();
    if (!validate) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error Ocurred'),
                  content: Text('Something Went Wrong Please Try again'),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Okay'))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlfocus.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your Products'), actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: saveForm)
        ]),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: initValue['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          } else
                            return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        }, //operation to be performed when the nxt button on soft keyboard is pressed
                        onSaved: (value) {
                          editedProduct = Product(
                              id: editedProduct.id,
                              title: value,
                              description: editedProduct.description,
                              imageUrl: editedProduct.imageUrl,
                              price: editedProduct.price,
                              isFavourite: editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: initValue['price'],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode:
                            _priceFocusNode, //set focus node here for the  form field
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: editedProduct.description,
                              imageUrl: editedProduct.imageUrl,
                              price: double.parse(value),
                              isFavourite: editedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null)
                            return 'Please enter a valid number';
                          if (double.parse(value) <= 0)
                            return 'Please enter a number greater than zero';
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: initValue['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          editedProduct = Product(
                              id: editedProduct.id,
                              title: editedProduct.title,
                              description: value,
                              imageUrl: editedProduct.imageUrl,
                              price: editedProduct.price,
                              isFavourite: editedProduct.isFavourite);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please add a description for product';
                          if (value.length < 10)
                            return 'Description should be greater than 10 characters';
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              //initialValue: initValue['imageUrl'],
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              focusNode: _imageUrlfocus,
                              onFieldSubmitted: (_) {
                                saveForm();
                              },
                              onSaved: (value) {
                                editedProduct = Product(
                                    id: editedProduct.id,
                                    title: editedProduct.title,
                                    description: editedProduct.description,
                                    imageUrl: value,
                                    price: editedProduct.price,
                                    isFavourite: editedProduct.isFavourite);
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please enter a URL for your product';
                                if (!value.startsWith('https') &&
                                    !value.startsWith('http'))
                                  return 'Please enter a valid URL';
                                if (!value.endsWith('.jpeg') &&
                                    !value.endsWith('png') &&
                                    !value.endsWith('.jpg'))
                                  return 'Please enter a valid URL';
                                return null;
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
