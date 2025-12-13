import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/transaction.dart';

class TransactionDetailPage extends StatelessWidget {
  final Transaction transaction;

  TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
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
