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
  DateTime date;
  DateTime updatedAt;
  List<TransactionProduct> entries;

  bool get isComplete => paymentStatus == PaymentStatus.paid;

  int get itemCount => entries.fold(0, (a, b) => a + b.amount);

  Transaction({
    required this.id,
    required this.buyerId,
    required this.amountPaid,
    required this.totalPrice,
    required this.amountDue,
    required this.paymentStatus,
    required this.entries,
    required this.date,
    required this.updatedAt,
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