import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void showPayDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // TODO: Validate transaction status and credentials first
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add payment'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: 'Enter payment amount',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                if (amount != null) {
                  pay(transactionId, amount);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void pay(String id, double amount) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
          Urls.paymentPay.replaceFirst('<uuid:id>', id), {
            'pay-amount': "$amount"});
      // TODO: Error handling
      // print(response);
    } catch (e) {
      print(e);
    }
    fetchTransaction();
  }

  void showCompleteDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // TODO: Validate transaction status and credentials first
        return AlertDialog(
          title: const Text('Complete transaction?'),
          content: const Text('Are you sure you want to complete this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                complete(transactionId);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void complete(String id) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
          Urls.paymentComplete.replaceFirst('<uuid:id>', id), {});
      // TODO: Error handling
      // print(response);
    } catch (e) {
      print(e);
    }
    fetchTransaction();
  }

  void showDeleteDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        // TODO: Validate transaction status and credentials first
        return AlertDialog(
          title: const Text('Complete transaction?'),
          content: const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context2).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context2).pop();
                if (await delete(transactionId)) {
                  // Pop current page
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> delete(String id) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.post(
          Urls.paymentDelete.replaceFirst('<uuid:id>', id), {});
      // TODO: Error handling
      print(response);
      if (response["status"] == 'success') {
        return true;
      }
    } catch (e) {
      print(e);
    }
    fetchTransaction();
    return false;
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

    final (statusIcon, statusLine, statusColor) = transaction.paymentStatus == PaymentStatus.complete
        ? (Icons.check, "Completed", Colors.green[900])
        : transaction.amountDue <= 0
        ? (Icons.pending_actions, "Fully paid, awaiting completion", Colors.blue[900])
        : (Icons.attach_money, "Not fully paid yet", Colors.yellow[900]);
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
                    leading: Icon(statusIcon),
                    title: const Text("Status"),
                    subtitle: Text(
                      statusLine,
                      style: TextStyle(
                        color: statusColor,
                      )
                    ),
                  ),
                  const Divider(height: 0),
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
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text("Total price"),
                    subtitle: Text("Rp ${transaction.totalPrice}"),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.paid),
                    title: const Text("Amount paid"),
                    subtitle: Text("Rp ${transaction.amountPaid}"),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.upload),
                    title: const Text("Amount due"),
                    subtitle: Text(
                      "Rp ${transaction.amountDue}",
                      style: TextStyle(
                        color: transaction.amountDue > 0 ? Colors.orange : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== TRANSACTION ACTIONS =====
            Row(
              children: [
                ElevatedButton(
                  onPressed: showPayDialog,
                  child: Text("Pay"),
                ),
                ElevatedButton(
                  onPressed: showCompleteDialog,
                  child: Text("Complete"),
                ),
                ElevatedButton(
                  onPressed: showDeleteDialog,
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
