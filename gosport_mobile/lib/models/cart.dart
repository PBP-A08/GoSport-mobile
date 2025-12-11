class Cart {
  final int id;
  final int totalItems;
  final double totalPrice;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.totalItems,
    required this.totalPrice,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      totalItems: json['total_items'],
      totalPrice: double.parse(json['total_price'].toString()),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}

class CartItem {
  final int id;
  final int quantity;
  final double price;
  final double subtotal;
  final int productId;
  final String productName;

  CartItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.productId,
    required this.productName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
      productId: json['product']['id'],
      productName: json['product']['product_name'],
    );
  }
}
