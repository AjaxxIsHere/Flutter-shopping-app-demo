import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cart_site/providers/auth_provider.dart';

// Navigation bar widget that is used across all screens in the app, providing a consistent header with navigation links and user authentication actions
// Widgets: - AppBar: displays the title and contains navigation links (home, cart) and authentication actions (login/register or logout based on user state)
class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const NavBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider?>();

    return AppBar(
      backgroundColor: Colors.blue[100],
      title: Row(
        children: [
          Text(title),
          const SizedBox(width: 32),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              height: 42,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.9),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                onChanged: (value) {
                  // TODO: Implement search functionality
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          icon: const Icon(Icons.home),
          tooltip: 'Home',
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (auth == null || !auth.isAuthenticated) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.pushNamed(context, '/cart');
                }
              },
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'My Cart',
            ),
          ],
        ),
        if (auth == null || !auth.isAuthenticated) ...[
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(Icons.login, size: 20),
            label: const Text('Login'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            icon: const Icon(Icons.person_add, size: 20),
            label: const Text('Register'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              onPressed: () async {
                await auth.logout();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }
}
