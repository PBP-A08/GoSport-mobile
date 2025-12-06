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

  @override
  void initState() {
    super.initState();
    fetchCheckoutReview();
  }

  Future<void> fetchCheckoutReview() async {
    final request = context.read<CookieRequest>();

    final response = await request.get(
      "${Urls.baseUrl}/cart/checkout-review-json/",
    );

    setState(() {
      data = response;
      isLoading = false;
    });
  }

  Future<void> placeOrder() async {
    final request = context.read<CookieRequest>();

    final response = await request.post("${Urls.baseUrl}/cart/checkout/", {});

    if (response["success"] == true) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/payment');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal melakukan checkout")));
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
                                "Subtotal: Rp ${item["subtotal"]}",
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
                        "Rp ${data!["total"]}",
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
