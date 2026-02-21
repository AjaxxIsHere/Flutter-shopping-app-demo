import 'package:cart_site/providers/get_product_provider.dart';
import 'package:cart_site/screens/products_details_screen.dart';
import 'package:cart_site/shared_widgets/product_card.dart';
import 'package:cart_site/shared_widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cart_site/providers/cart_provider.dart';

// Home screen displaying the list of products fetched from the API in a responsive grid layout
// Widgets: - ProductCard: custom widget to display product information and handle user interactions (view details, add to cart)

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 2; 
              if (width > 1200) {
                crossAxisCount = 5;
              } else if (width > 900) {
                crossAxisCount = 4;
              } else if (width > 600) {
                crossAxisCount = 3;
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7, 
                  ),
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainLayout(
                              title: 'Product Details',
                              child: ProductDetailScreen(product: product),
                            ),
                          ),
                        );
                      },
                      onAdd: () {
                        try {
                          final cart = context.read<CartProvider>();
                          cart.add(product);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong!')));
                        }
                      },
                    );
                  },
                ),
              );
            },
          );
  }
}
