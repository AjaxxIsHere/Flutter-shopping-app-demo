import '../core/api_client.dart';
import '../models/products_model.dart';

// Product service responsible for fetching product data from the API
// Methods: - fetchProducts: asynchronous method to get the list of products from the API and convert it into a list of Product objects
class ProductService {
  final dioClient = ApiClient.instance;

  Future<List<Product>> fetchProducts() async {
    final resp = await dioClient.get('/products');
    final List<dynamic> data = resp.data;
    return data.map((e) => Product.fromJson(e)).toList();
  }
}
