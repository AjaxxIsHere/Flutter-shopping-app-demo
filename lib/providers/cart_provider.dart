import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/products_model.dart';


// Cart provider managing the shopping cart state and persistence
// Fields: - _items: list of products currently in the cart
//         - _currentUser: username associated with the current cart (null for guest)
// Methods: - add: adds a product to the cart and saves it
//          - remove: removes a product from the cart and saves it
//          - clear: empties the cart and saves it
//          - setUser: switches cart context to a specific username (or guest) and loads the corresponding cart
//          - count: getter for the number of items in the cart
//          - total: getter for the total price of items in the cart
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];
  List<Product> get items => List.unmodifiable(_items);
  String? _currentUser;

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    // default: load guest cart
    await _loadCartForKey('cart_guest');
  }

  Future<void> _loadCartForKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(key);
    _items.clear();
    if (raw != null) {
      _items.addAll(raw.map((s) => Product.fromJson(json.decode(s))));
    }
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = _items.map((p) => json.encode(p.toJson())).toList();
    final key = _currentUser != null ? 'cart_${_currentUser!}' : 'cart_guest';
    await prefs.setStringList(key, raw);
  }
  
  void add(Product p) {
    _items.add(p);
    _saveCart();
    notifyListeners();
  }

  void remove(Product p) {
    final index = _items.indexWhere((e) => e.id == p.id);
    if (index != -1) {
      _items.removeAt(index);
    }
    _saveCart();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  /// Switch cart context to a specific username (or null for guest).
  Future<void> setUser(String? username) async {
    if (_currentUser == username) return;
    _currentUser = username;
    final key = _currentUser != null ? 'cart_${_currentUser!}' : 'cart_guest';
    await _loadCartForKey(key);
  }

  int get count => _items.length;

  double get total => _items.fold(0.0, (s, p) => s + p.price);
}
