import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product>? _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red shirt',
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

  final String? token;
  Products([this.token, this._items]);

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-28ba1-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  var _showFavoritesOnly = false;

  List<Product> get items {
    if (_items != null) {
      if (_showFavoritesOnly)
        return _items!
            .where((prodItem) => prodItem.isFavorite == true)
            .toList();
    }
    return [...?_items]; //copy of the list
  }

  List<Product>? get favoriteItems {
    return _items?.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product? findById(String id) {
    return _items?.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-28ba1-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
          title: product.title,
          id: json.decode(response.body)['name'],
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      if (_items != null) {
        _items!.add(newProduct);
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items!.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
        'https://flutter-shop-28ba1-default-rtdb.firebaseio.com/products/$id.json?auth=$token',
      );
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      if(_items != null){
      _items![prodIndex] = newProduct;
      }
      notifyListeners();
    }
  }

  var emptyProduct =
      Product(description: '', id: '', imageUrl: '', price: 0, title: '');

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://flutter-shop-28ba1-default-rtdb.firebaseio.com/products/$id.json?auth=$token',
    );
    if(_items!=null){
    final existingProductIndex =
        _items!.indexWhere((element) => element.id == id);
    var existingProduct = _items![existingProductIndex];
    _items!.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    
    existingProduct = emptyProduct;
    }
  }
}
