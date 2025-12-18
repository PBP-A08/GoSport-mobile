import 'package:flutter/material.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:gosport_mobile/screens/payment/transaction_card.dart';
import 'package:gosport_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:gosport_mobile/models/transaction.dart';
import 'package:provider/provider.dart';

class PaymentDashboard extends StatefulWidget {

  const PaymentDashboard({super.key});

  @override
  State<PaymentDashboard> createState() => _PaymentDashboardState();

}

class _PaymentDashboardState extends State<PaymentDashboard> {

  final List<Transaction> fakeTransactionData = [
    Transaction(
      id: "00000000-0000-0000-0000-000000000001",
      buyerId: 1,
      amountPaid: 500000.0,
      totalPrice: 600000.0,
      amountDue: 100000.0,
      paymentStatus: PaymentStatus.pending,
      date: DateTime.now(),
      updatedAt: DateTime.now(),
      entries: [
        TransactionProduct(
          productId: "",
          productName: "Ramuan Fokus Model SB-A-01",
          amount: 20,
          price: 30000
        ),
        TransactionProduct(
            productId: "",
            productName: "Bola Homing",
            amount: 20,
            price: 30000
        ),
        TransactionProduct(
            productId: "",
            productName: "Gawang Lipat",
            amount: 20,
            price: 30000
        ),
      ],
    ),
    Transaction(
      id: "00000000-0000-0000-0000-000000000001",
      buyerId: 1,
      amountPaid: 500000.0,
      totalPrice: 600000.0,
      amountDue: 100000.0,
      paymentStatus: PaymentStatus.pending,
      date: DateTime.now(),
      updatedAt: DateTime.now(),
      entries: [
        TransactionProduct(
            productId: "",
            productName: "Bola Homing",
            amount: 20,
            price: 30000
        ),
      ],
    ),
    Transaction(
      id: "00000000-0000-0000-0000-000000000001",
      buyerId: 1,
      amountPaid: 500000.0,
      totalPrice: 600000.0,
      amountDue: 100000.0,
      paymentStatus: PaymentStatus.pending,
      date: DateTime.now(),
      updatedAt: DateTime.now(),
      entries: [
        TransactionProduct(
            productId: "",
            productName: "Bola Homing",
            amount: 20,
            price: 30000
        ),
      ],
    ),
  ];

  Future<List<Transaction>> fetchTransactions(CookieRequest request) async {
    final response = await request.get(Urls.transactionsJson);

    var data = response;

    List<Transaction> transactions = [];
    for (var d in data) {
      if (d != null) {
        transactions.add(Transaction.fromJson(d));
      }
    }

    return transactions;
  }
  
  @override
  Widget build(BuildContext context) {
    CookieRequest request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      drawer: LeftDrawer(),
      body: FutureBuilder(
        future: fetchTransactions(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            debugPrint('Snapshot error: ${snapshot.error}');
            return Text("Oh tidak");
          } else if (!snapshot.hasData) {
            return Text("Loading...");
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final Transaction transaction = snapshot.data![index];
                return TransactionCard(transaction: transaction);
              },
            );
          }
        },
      ),
    );
  }
}