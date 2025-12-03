import 'package:flutter/material.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:gosport_mobile/models/transaction.dart';

class TransactionDetailPage extends StatelessWidget {
  Transaction transaction;
  TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              // == TRANSACTION ATTRIBUTES ==
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          Text(
                              "Created at",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )
                          ),
                          Text(
                            transaction.date.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            "Updated at",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            transaction.updatedAt.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                              "# items",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )
                          ),
                          Text(
                            "${transaction.itemCount}",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // == TRANSACTION ENTRIES ==
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Items",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Column(
                        children: transaction.entries.map((entry) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.productName,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "${entry.amount}",
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "${entry.totalPrice}",
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}