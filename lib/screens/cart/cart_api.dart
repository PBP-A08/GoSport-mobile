import 'package:gosport_mobile/models/cart.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CartApi {
  // ADD TO CART
  static Future<void> addToCart(
      CookieRequest request, String productId) async {
    await request.post(
      "${Urls.cartAdd}$productId/",
      {},
    );
  }

  // GET CART
  static Future<Cart> fetchCart(CookieRequest request) async {
    final response = await request.get(Urls.cartJson);
    return Cart.fromJson(response);
  }

  // UPDATE QTY
  static Future<void> updateQuantity(
      CookieRequest request, int cartItemId, int newQty) async {
    await request.post(
      "${Urls.cartUpdate}$cartItemId/",
      {"quantity": newQty.toString()},
    );
  }

  // DELETE ITEM
  static Future<void> deleteItem(
      CookieRequest request, int cartItemId) async {
    await request.post(
      "${Urls.cartDelete}$cartItemId/",
      {},
    );
  }
}
