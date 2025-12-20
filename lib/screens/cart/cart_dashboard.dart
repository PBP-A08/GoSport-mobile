import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/cart.dart';
import 'cart_api.dart';
import 'cart_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';


class CartDashboard extends StatefulWidget {
  const CartDashboard({super.key});

  @override
  State<CartDashboard> createState() => _CartDashboardState();
}

class _CartDashboardState extends State<CartDashboard> {
  Cart? cart;
  bool isLoading = true;
  late CookieRequest request;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    request = context.read<CookieRequest>();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(loadCart);
  }

  Future<void> loadCart() async {
    final data = await CartApi.fetchCart(request);

    if (!mounted) return;
    setState(() {
      cart = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || cart == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart!.items.length,
              itemBuilder: (context, index) {
                final item = cart!.items[index];
                return CartItemCard(
                  item: item,
                  onDelete: () async {
                    final request = context.read<CookieRequest>();
                    await CartApi.deleteItem(request, item.id);
                    loadCart();
                  },
                  onPlus: () async {
                    final request = context.read<CookieRequest>();
                    await CartApi.updateQuantity(request, item.id, item.quantity + 1);
                    loadCart();
                  },
                  onMinus: () async {
                    if (item.quantity > 1) {
                      final request = context.read<CookieRequest>();
                      await CartApi.updateQuantity(request, item.id, item.quantity - 1);
                      loadCart();
                    }
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Total Item: ${cart!.totalItems}"),
                const SizedBox(height: 8),
                Text(
                  "Total Price: \$ ${cart!.totalPrice}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if ((cart!.totalItems > 0) && (cart!.totalPrice > 0)){
                        Navigator.pushNamed(context, '/checkout-review');
                      } else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text("Your cart looks empty. Start shopping to add items!"),
                              ),
                            );
                      }
                    },
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
