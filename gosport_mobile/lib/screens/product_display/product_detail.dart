import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/product.dart';
import 'package:gosport_mobile/constants/urls.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  // Helper to format date
  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final fields = product.fields;
    
    // Determine image URL. Use proxy if it's an external URL to avoid CORS/Hotlinking issues
    String imageUrl = fields.thumbnail;
    if (fields.thumbnail.startsWith('http')) {
        imageUrl = Urls.baseUrl+'/proxy-image/?url=${Uri.encodeComponent(fields.thumbnail)}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        backgroundColor: Colors.red[700], // CHANGED TO RED
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PRODUCT IMAGE
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text("Image unavailable", style: TextStyle(color: Colors.grey[600]))
                      ],
                    ),
                  ),
                ),
                // Discount Badge overlay
                if (fields.discountPercent > 0)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Text(
                        '-${fields.discountPercent}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. HEADER INFO (Category & Rating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          fields.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${fields.avgRating} / 5.0',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. TITLE
                  Text(
                    fields.productName,
                    style: const TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 4. PRICE SECTION
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        fields.specialPrice, // Display the active price
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (fields.oldPrice != fields.specialPrice)
                        Text(
                          fields.oldPrice,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 5. SELLER & STOCK INFO
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                         CircleAvatar(
                          backgroundColor: Colors.red[100],
                          child: Icon(Icons.store, color: Colors.red[700]),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Seller: ${fields.seller}", // Seller Field
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              fields.stock > 0 ? "In Stock: ${fields.stock}" : "Out of Stock",
                              style: TextStyle(
                                color: fields.stock > 0 ? Colors.green[700] : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(height: 32),

                  // 6. DESCRIPTION
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fields.description,
                    style: TextStyle(
                      fontSize: 15.0,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Timestamp (Optional footer)
                  Text(
                    "Listed on: ${_formatDate(fields.createdAt)}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Optional: Add to Cart Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: fields.stock > 0 ? Colors.red[700] : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: fields.stock > 0 
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Add to cart feature coming soon!")),
                );
              } 
            : null,
          child: Text(
            fields.stock > 0 ? "Add to Cart" : "Out of Stock",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}