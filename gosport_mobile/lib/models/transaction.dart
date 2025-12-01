enum PaymentStatus {

  due(display: "Due"),
  paid(display: "Paid");

  final String display;

  const PaymentStatus({required this.display});

}

class Transaction {

  String id;
  String buyerId;
  double amountPaid;
  double totalPrice;
  double amountDue;
  PaymentStatus paymentStatus;
  List<TransactionProduct> entries;

  bool get isComplete => paymentStatus == PaymentStatus.paid;

  Transaction({
    required this.id,
    required this.buyerId,
    required this.amountPaid,
    required this.totalPrice,
    required this.amountDue,
    required this.paymentStatus,
    required this.entries,
  });

}

class TransactionProduct {

  String productId;
  String productName;
  int amount;
  double price;

  double get totalPrice => amount * price;

  TransactionProduct({
    required this.productId,
    required this.productName,
    required this.amount,
    required this.price,
  });

}