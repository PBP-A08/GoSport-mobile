import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:gosport_mobile/constants/urls.dart';

class CheckoutReviewScreen extends StatefulWidget {
  const CheckoutReviewScreen({super.key});

  @override
  State<CheckoutReviewScreen> createState() => _CheckoutReviewScreenState();
}

class _CheckoutReviewScreenState extends State<CheckoutReviewScreen> {
  bool isLoading = true;
  Map<String, dynamic>? data;
  late CookieRequest request;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    request = context.read<CookieRequest>();
    fetchCheckoutReview();
  }

  Future<void> fetchCheckoutReview() async {
    try {
      final response = await request.get(
        "${Urls.baseUrl}/cart/checkout-review-json/",
      );

      if (!mounted) return;

      setState(() {
        data = response;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Checkout review error: $e");
    }
  }

  Future<void> placeOrder() async {
    try {
      final response = await request.post(
        Urls.cartCheckout,
        {},
      );

      if (!mounted) return;

      if (response["success"] == true) {
        Navigator.pushReplacementNamed(
          context, 
          '/payment',
          arguments: {
            "transaction_id": response["transaction_id"],
            "total": response["total"],
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to checkout")),
        );
      }
    } catch (e) {
      debugPrint("Checkout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Order")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "User Information",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text("Username: ${data!["user"]["username"]}"),
                          Text("Address: ${data!["user"]["address"] ?? "-"}"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Card(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: data!["items"].length,
                        itemBuilder: (context, index) {
                          final item = data!["items"][index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["product_name"]),
                              Text("Qty: ${item["quantity"]}"),
                              Text(
                                "Subtotal: \$ ${item["subtotal"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "\$ ${data!["total"]}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: placeOrder,
                      child: const Text("Place Order"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
