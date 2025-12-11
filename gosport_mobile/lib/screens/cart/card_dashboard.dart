import 'package:flutter/material.dart';
import '../../models/cart.dart';
import 'cart_api.dart';
import 'cart_card.dart';

class CartDashboard extends StatefulWidget {
  const CartDashboard({super.key});

  @override
  State<CartDashboard> createState() => _CartDashboardState();
}

class _CartDashboardState extends State<CartDashboard> {
  Cart? cart;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final data = await CartApi.fetchCart();
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
      appBar: AppBar(title: const Text("Keranjang Belanja")),
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
                    await CartApi.deleteItem(item.id);
                    loadCart();
                  },
                  onPlus: () async {
                    await CartApi.updateQuantity(item.id, item.quantity + 1);
                    loadCart();
                  },
                  onMinus: () async {
                    if (item.quantity > 1) {
                      await CartApi.updateQuantity(item.id, item.quantity - 1);
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
                  "Total Harga: Rp ${cart!.totalPrice}",
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
                      Navigator.pushNamed(context, '/checkout-review');
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
