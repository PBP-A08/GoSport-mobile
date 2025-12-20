import 'package:flutter/material.dart';
import 'package:gosport_mobile/screens/product_display/product_form.dart';
import 'package:gosport_mobile/screens/product_display/product_list.dart';
import 'package:gosport_mobile/screens/menu.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:gosport_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  const ItemCard(this.item, {super.key});
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: Color(0xFF9D0C0C),
      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (item.name == "Add Product") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductFormPage()),
            );
          } else if (item.name == "See Sports Products") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductListPage()),
            );
          } else if (item.name == "My Cart") {
            Navigator.pushNamed(context, '/cart');
          } else if (item.name == "Payment") {
            Navigator.pushNamed(context, '/payment');
          } else if (item.name == "Logout") {
            final response = await request.logout(Urls.logout);

            final status = response['status'];
            final message = response['message'] ?? 'Logged out';

            if (!context.mounted) return;

            if (status == 'success') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
