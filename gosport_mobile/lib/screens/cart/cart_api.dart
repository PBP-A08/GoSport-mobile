import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gosport_mobile/models/cart.dart';
import 'package:gosport_mobile/constants/urls.dart';

class CartApi {
  // GET CART
  static Future<Cart> fetchCart() async {
    final response = await http.get(Uri.parse(Urls.cartJson));

    final data = jsonDecode(response.body);
    return Cart.fromJson(data);
  }

  // UPDATE QTY
  static Future<void> updateQuantity(int cartItemId, int newQty) async {
    await http.put(
      Uri.parse("${Urls.cartUpdate}$cartItemId/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"quantity": newQty}),
    );
  }

  // DELETE ITEM
  static Future<void> deleteItem(int cartItemId) async {
    await http.delete(Uri.parse("${Urls.cartDelete}$cartItemId/"));
  }
}
