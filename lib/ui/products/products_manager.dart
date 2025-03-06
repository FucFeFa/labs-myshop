import 'package:flutter/foundation.dart';

import '../../models/product.dart';
import '../../services/products_service.dart';

class ProductsManager with ChangeNotifier {
  final ProductsService _productsService = ProductsService();
  final List<Product> _items = [];

  int get itemCount {
     return _items.length; 
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if(newProduct != null) {
      _items.add(newProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);

    if(index > 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    _items.removeAt(index);
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final fetchedProducts = await _productsService.fetchProducts();
    _items.clear();
    _items.addAll(fetchedProducts);
    notifyListeners();
  }

  Future<void> fetchUserProducts() async {
    final fetchedProducts = await _productsService.fetchProducts(
      filteredByUser: true,
    );
    _items.clear();
    _items.addAll(fetchedProducts);
    notifyListeners();
  }
}