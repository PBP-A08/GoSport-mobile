import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/product.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:gosport_mobile/screens/cart/cart_api.dart';
import 'package:gosport_mobile/screens/rating/rating_list.dart';
import 'package:gosport_mobile/screens/rating/rating_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  // ================= HELPER =================
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ======== PLACEHOLDER MAP =========
  static const Map<String, String> placeholderMap = {
    "stumps":
        "https://www.khelmart.com/pub/media/catalog/product/cache/712b931dac1b924a11d1b7282ad89910/g/a/ga_ca_0001_large.jpg",
    "cap":
        "https://media.monotaro.id/mid01/big/Keselamatan%20Kerja(K3)%2C%20Perlindungan%20Diri%20%26%20Kesehatan/Alat%20Keselamatan%20Kerja/Helm%20Safety/Topi%20Kerja/SAFE-T%20Sport%20Cap/SAFE-T%20Sport%20Cap%20SM933%20Reflektif%201pc/32S038061110-1.jpg",
    "roller":
        "https://contents.mediadecathlon.com/p2766703/k\$63a3176109679a79886f604b5ea6a944/sepatu-roda-anak-pemula-learn-100-krem-oxelo-8580562.jpg",
    "skate":
        "https://contents.mediadecathlon.com/p2766703/k\$63a3176109679a79886f604b5ea6a944/sepatu-roda-anak-pemula-learn-100-krem-oxelo-8580562.jpg",
    "guard":
        "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/103/MTA-179366600/aolikes_7731_aolikes_knee_sleeve_wrap_support_pad_deker_lutut_kaki_acl_leg_guard_full01_lym0kn46.jpg",
    "shirt":
        "https://www.skechers.id/media/catalog/product/cache/385762a622ece62f2fa8ee98fb5e338a/0/8/0888-SKEGMS25V7BLCOB0XL-1.jpg",
    "goggle":
        "https://contents.mediadecathlon.com/p2867701/k\$2b32713a0b0806b1022d3f0390e28cff/kacamata-renang-anak-xbase-lensa-clear-biru-decathlon-8926969.jpg",
    "shoes":
        "https://www.skechers.id/media/catalog/product/cache/385762a622ece62f2fa8ee98fb5e338a/0/1/01-SKECHERS-F34RUSKE0-SKE220321NTM-Natural.jpg",
    "glove":
        "https://contents.mediadecathlon.com/p2069799/k\$57cbda153fce3b94698cbe07148dc4c4/sarung-tangan-gym-fitness-latihan-beban-100-corength-8595161.jpg",
    "kitbag": "https://m.media-amazon.com/images/I/71lwjA1MYqL._SX679_.jpg",
    "badminton":
        "https://images.tokopedia.net/img/HCoJbh/2025/3/6/62f47d53-ebd5-4e40-8a67-794a3fa72636.jpg",
    "racket":
        "https://images.tokopedia.net/img/HCoJbh/2025/3/6/62f47d53-ebd5-4e40-8a67-794a3fa72636.jpg",
    "football":
        "https://sportsandgames.co.tt/wp-content/uploads/2022/05/blog_football.jpg",
    "soccer":
        "https://sportsandgames.co.tt/wp-content/uploads/2022/05/blog_football.jpg",
    "basketball":
        "https://finnsbeachclub.com/wp-content/uploads/2024/09/basketball-court-ball-and-sports-match-or-competi-2023-11-27-04-58-17-utc.jpg",
    "volleyball": "https://www.fivb.com/wp-content/uploads/2024/03/rules1.jpg",
    "hockey":
        "https://upload.wikimedia.org/wikipedia/commons/3/39/Pittsburgh_Penguins%2C_Washington_Capitals%2C_Bryan_Rust_%2833744033514%29.jpg",
    "tennis":
        "https://tdsportswear.com/wp-content/uploads/2025/01/d56-1170x658.png",
    "sport": "https://img.freepik.com/free-photo/sports-tools_53876-138077.jpg",
  };

  // ======== GET PLACEHOLDER BY KEYWORD =========
  String getPlaceholderByKeyword(String name, String category) {
    final text = "${name.toLowerCase()} ${category.toLowerCase()}";
    for (final key in placeholderMap.keys) {
      if (text.contains(key)) {
        return placeholderMap[key]!;
      }
    }
    return placeholderMap["sport"]!;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    final fields = product.fields;
    final id = product.pk;
    final role = request.jsonData['role'];
    // ================= IMAGE LOGIC =================
    final raw = fields.thumbnail.trim();
    String imageUrl;
    if (raw.isEmpty) {
      imageUrl = getPlaceholderByKeyword(fields.productName, fields.category);
    } else {
      final encoded = Uri.encodeComponent(raw);
      imageUrl = "${Urls.baseUrl}/proxy-image/?url=$encoded";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        const Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Image unavailable",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                // Discount badge
                if (fields.discountPercent > 0)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
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
            // ================= PRODUCT INFO =================
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Product name
                  Text(
                    fields.productName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        fields.specialPrice,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (fields.oldPrice != fields.specialPrice)
                        Text(
                          fields.oldPrice,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Seller & Stock
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
                              "Seller: ${fields.seller}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              fields.stock > 0
                                  ? "In Stock: ${fields.stock}"
                                  : "Out of Stock",
                              style: TextStyle(
                                color: fields.stock > 0
                                    ? Colors.green[700]
                                    : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fields.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RatingListPage(
                            productId: id,
                            productName: fields.productName,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "All review",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                  // Listed date
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (role == 'buyer')
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fields.stock > 0
                        ? Colors.amber
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingFormPage(
                          productId: id,
                          productName: fields.productName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Rate",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: fields.stock > 0
                      ? Colors.red[700]
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: fields.stock > 0
                    ? () async {
                        await CartApi.addToCart(request, id);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to Cart")),
                        );
                      }
                    : null,
                child: Text(
                  fields.stock > 0 ? "Add to Cart" : "Out of Stock",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
