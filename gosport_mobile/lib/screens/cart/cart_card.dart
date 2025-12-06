import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/cart.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete;
  final VoidCallback onPlus;
  final VoidCallback onMinus;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onPlus,
    required this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Harga: Rp ${item.price}"),
                  Text("Subtotal: Rp ${item.subtotal}"),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.remove), onPressed: onMinus),
                Text(item.quantity.toString()),
                IconButton(icon: const Icon(Icons.add), onPressed: onPlus),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
