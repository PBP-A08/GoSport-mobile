import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/transaction.dart';
import 'package:gosport_mobile/screens/payment/transaction_detail.dart';

class TransactionCard extends StatelessWidget {
  Transaction transaction;

  TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final (statusIcon, statusLine, statusColor) = transaction.paymentStatus == PaymentStatus.complete
        ? (Icons.check, "Completed", Colors.green[900])
        : transaction.amountDue <= 0
        ? (Icons.pending_actions, "Fully paid, awaiting completion", Colors.blue[900])
        : (Icons.attach_money, "Not fully paid yet", Colors.yellow[900]);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailPage(transactionId: transaction.id),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(4),
          child: Row(
            children: [
              Icon(
                statusIcon,
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
                  Row(
                    children: [
                      Text(
                        "${transaction.itemCount} items",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        "·",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        statusLine,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
