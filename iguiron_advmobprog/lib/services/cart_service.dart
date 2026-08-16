import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/cart.dart';

class CartService {
  Future<List<Cart>> getAllCarts() async {
    final response = await http.get(Uri.parse('$host/carts'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List cartsJson = data['carts'] ?? [];
      return cartsJson.map((json) => Cart.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load carts');
    }
  }

  // enhancement 3: fetch a single cart by its own id
  Future<Cart> getCartById(int cartId) async {
    final response = await http.get(Uri.parse('$host/carts/$cartId'));

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cart $cartId');
    }
  }

  // enhancement 3: fetch the cart belonging to one user so cart_screen can render only that user's cart instead of every cart in the store.
  Future<Cart?> getCartByUserId(int userId) async {
    final response = await http.get(Uri.parse('$host/carts/user/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List cartsJson = data['carts'] ?? [];
      if (cartsJson.isEmpty) return null;
      return Cart.fromJson(cartsJson.first);
    } else {
      throw Exception('Failed to load cart for user $userId');
    }
  }

  // enhancement 3: add a product to a user's cart 
  Future<Cart> addToCart(int userId, List<Map<String, dynamic>> products) async {
    final response = await http.post(
      Uri.parse('$host/carts/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'products': products}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add product to cart');
    }
  }
}
