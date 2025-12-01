import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  Transaction transaction;

  TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Icon(
              transaction.paymentStatus == PaymentStatus.paid
              ? Icons.check : Icons.attach_money,
              size: 48,
            ),
            SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.date.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${transaction.itemCount} items",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}