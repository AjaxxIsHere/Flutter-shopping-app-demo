import 'package:flutter/material.dart';
import '../models/products_model.dart';
import '../services/product_service.dart';

// Product provider responsible for fetching and storing the list of products from the API
// Fields: - products: list of Product objects fetched from the API
//         - isLoading: indicates if the product data is currently being fetched
// Methods: - fetchProducts: asynchronous method to fetch products from the API and update the state
class ProductProvider extends ChangeNotifier {
  List<Product> products = [];
  bool isLoading = true;

  final ProductService _service = ProductService();

  Future<void> fetchProducts() async {
    try {
      final data = await _service.fetchProducts();
      products = data;
    } catch (e) {
      debugPrint('Error fetching products: $e');
      SnackBar(content: Text('No products to be found!'));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}