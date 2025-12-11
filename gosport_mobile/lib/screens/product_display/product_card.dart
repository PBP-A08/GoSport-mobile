import 'package:flutter/material.dart';
import 'package:gosport_mobile/models/product.dart';
import 'package:gosport_mobile/constants/urls.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

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

  // ======== BUILD IMAGE URL =========
  String _buildImageUrl(Fields fields) {
    final raw = fields.thumbnail.trim();

    if (raw.isEmpty) {
      return getPlaceholderByKeyword(fields.productName, fields.category);
    }

    final encoded = Uri.encodeComponent(raw);
    return "${Urls.baseUrl}/proxy-image/?url=$encoded";
  }

  @override
  Widget build(BuildContext context) {
    final fields = product.fields;
    final imageUrl = _buildImageUrl(fields);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= IMAGE =================
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // ============== NAME ====================
                Text(
                  fields.productName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // ============= CATEGORY =================
                Text(
                  "Category: ${fields.category}",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                // ============ DESCRIPTION ===============
                Text(
                  fields.description.length > 100
                      ? "${fields.description.substring(0, 100)}..."
                      : fields.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 8),
                // Featured badge
                if (fields.specialPrice != "0")
                  const Text(
                    "Featured",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
