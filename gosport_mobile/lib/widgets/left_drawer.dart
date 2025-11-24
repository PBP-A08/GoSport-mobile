import 'package:flutter/material.dart';
import 'package:gosport_mobile/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gosport_mobile/constants/urls.dart';
import 'package:gosport_mobile/screens/login.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final request = context.watch<CookieRequest>();
    final role = request.jsonData['role'];

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF9D0C0C)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'GoSport',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "All the best sports products are here!",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          // HOME
          ListTile(
            leading: Icon(Icons.home_outlined, color: primary),
            title: Text(
              'Home',
              style: TextStyle(color: primary, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),

          // PROFILE
          if (role != 'admin')
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),

          const Divider(),

          // LOGOUT BUTTON
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade700),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              final response = await request.logout(Urls.logout);

              if (!context.mounted) return;

              if (response['status'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully logged out!')),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response['message'] ?? 'Logout failed'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
