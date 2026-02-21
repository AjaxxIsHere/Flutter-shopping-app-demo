import 'package:cart_site/providers/get_product_provider.dart';
import 'package:cart_site/screens/home_screen.dart';
import 'package:cart_site/screens/cart_screen.dart';
import 'package:cart_site/screens/login_screen.dart';
import 'package:cart_site/screens/register_screen.dart';
import 'package:cart_site/providers/cart_provider.dart';
import 'package:cart_site/providers/auth_provider.dart';
import 'package:cart_site/shared_widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main entry point of the application, setting up the providers for state management and defining the routes for navigation between different screens (home, cart, login, register) using a consistent main layout with a navigation bar.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) {
            cart ??= CartProvider();
            cart.setUser(auth.username);
            return cart;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const MainLayout(
                  title: 'Cheap\'s N Stuff',
                  child: ProductScreen(),
                ),
            '/cart': (context) => const MainLayout(
                  title: 'My Cart',
                  child: CartScreen(),
                ),
            '/login': (context) => const MainLayout(
                  title: 'Login',
                  child: LoginScreen(),
                ),
            '/register': (context) => const MainLayout(
                  title: 'Register',
                  child: RegisterScreen(),
                ),
          },
        );
  }
}
