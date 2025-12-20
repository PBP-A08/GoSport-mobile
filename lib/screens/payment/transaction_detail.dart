import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/transaction.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gosport_mobile/constants/urls.dart';

class TransactionDetailPage extends StatefulWidget {

  final String transactionId;
  TransactionDetailPage({super.key, required this.transactionId});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState(transactionId: transactionId);

}

class _TransactionDetailPageState extends State<TransactionDetailPage> {

  final String transactionId;
  bool isLoading = true;
  bool isError = false;

  late Transaction transaction;

  _TransactionDetailPageState({required this.transactionId});

  @override
  void initState() {
    super.initState();
    fetchTransaction();
  }

  void fetchTransaction() async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.get(
        Urls.transactionJsonById.replaceFirst("<uuid:id>", transactionId));
      // TODO: Add 404 handling
      if (mounted) {
        setState(() {
          transaction = Transaction.fromJson(response);
          isLoading = false;
          isError = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
        isError = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (isError) {
      return Scaffold(
        appBar: AppBar(title: const Text("Transaction Details")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text("An error occurred"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchTransaction,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );

    }

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TRANSACTION SUMMARY =====
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text("Created at"),
                    subtitle: Text(
                      transaction.date.toString().substring(0, 16),
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.update),
                    title: const Text("Updated at"),
                    subtitle: Text(
                      transaction.updatedAt.toString().substring(0, 16),
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: const Text("Total Items"),
                    subtitle: Text("${transaction.itemCount} items"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== TRANSACTION ACTIONS =====
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Pay"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Complete"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Delete"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===== TRANSACTION ITEMS =====
            const Text(
              "Items",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: transaction.entries.map((entry) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          entry.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Qty: ${entry.amount}"),
                        trailing: Text(
                          "Rp ${entry.totalPrice}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      if (entry != transaction.entries.last)
                        const Divider(height: 0),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
