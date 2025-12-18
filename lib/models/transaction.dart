enum PaymentStatus {

  pending(display: "Pending"),
  complete(display: "Complete");

  final String display;

  const PaymentStatus({required this.display});

}

class Transaction {

  String id;
  int buyerId;
  double amountPaid;
  double totalPrice;
  double amountDue;
  PaymentStatus paymentStatus;
  DateTime date;
  DateTime updatedAt;
  List<TransactionProduct> entries;

  bool get isComplete => paymentStatus == PaymentStatus.complete;

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

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],
      buyerId: json["buyer_id"],
      amountPaid: json["amount_paid"],
      totalPrice: json["total_price"],
      amountDue: json["amount_due"],
      paymentStatus: PaymentStatus.values.byName(json["payment_status"]),
      date: DateTime.parse(json["date"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      entries: TransactionProduct.fromJsonList(json["entries"]),
    );
  }

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

  factory TransactionProduct.fromJson(json) => TransactionProduct(
    productId: json["id"],
    productName: json["name"],
    amount: json["amount"],
    price: json["price"],
  );

  static List<TransactionProduct> fromJsonList(json) {
    List<TransactionProduct> result = [];
    for (var entry in json) {
      result.add(TransactionProduct.fromJson(entry));
    }
    return result;
  }

}