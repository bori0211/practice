import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

mixin ProductsModel on Model {
  List<Product> _products = [];
  String _selectedProductId;
  bool _showFavorites = false;
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selectedProductId;
    });
  }

  Product get selectedProduct {
    if (_selectedProductId == null) return null;
    return _products.firstWhere((Product product) {
      return product.id == _selectedProductId;
    });
  }

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.from(_products.where((Product product) => product.isFavorite).toList());
    }
    return List.from(_products);
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addProduct(String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> insertData = {
      'title': title,
      'description': description,
      'image': 'https://www.datafirst.co.kr/img/header/home-full-1.png',
      'price': price
    };
    try {
      final http.Response response = await http.post(
        'https://datafirst-flutter-course.firebaseio.com/products.json',
        body: json.encode(insertData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(id: responseData['name'], title: title, description: description, image: image, price: price);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateProduct(String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image': 'https://www.datafirst.co.kr/img/header/home-full-1.png',
      'price': price
    };

    return http
        .put('https://datafirst-flutter-course.firebaseio.com/products/${selectedProduct.id}.json', body: json.encode(updateData))
        .then((http.Response response) {
      final Product updatedProduct = Product(id: selectedProduct.id, title: title, description: description, image: image, price: price);
      _products[selectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    notifyListeners();
    return http.delete('https://datafirst-flutter-course.firebaseio.com/products/${selectedProduct.id}.json').then((http.Response response) {
      _products.removeAt(selectedProductIndex);
      _selectedProductId = null;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get('https://datafirst-flutter-course.firebaseio.com/products.json').then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, productData) {
        final Product product = Product(
            id: productId, title: productData['title'], description: productData['description'], image: productData['image'], price: productData['price']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selectedProductId = null;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = _products[selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selectedProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
