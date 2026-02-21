import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import 'package:cart_site/shared_widgets/star_rater.dart';
import 'package:cart_site/providers/cart_provider.dart';
import 'package:cart_site/providers/auth_provider.dart';

// Product detail screen showing comprehensive information about a selected product and allowing users to add it to their cart with a specified quantity
// Widgets: - StarRater: custom widget to display the product rating visually with stars
// Logic: - Quantity selector with increment and decrement buttons, ensuring a minimum quantity of 1
//        - Add to Cart button checks if the user is authenticated before adding items to the cart, prompting login if not authenticated
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        // Image Section
        final imageSection = Container(
          height: isWide ? 500 : 300,
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Hero(
            tag: 'product_${widget.product.id}',
            child: Image.network(widget.product.image, fit: BoxFit.contain),
          ),
        );

        // Details Section
        final detailsSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                StarRater(
                  rating: widget.product.rating,
                  iconSize: 20,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '\$${widget.product.price}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Description',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                        icon: const Icon(Icons.remove),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                      Text(
                        '$quantity',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                            ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: const Icon(Icons.add),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      final cart = context.read<CartProvider>();
                      final auth = context.read<AuthProvider>();
                      if (!auth.isAuthenticated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please log in to add items to cart'),
                          ),
                        );
                        Navigator.pushNamed(context, '/login');
                        return;
                      } else {
                        for (int i = 0; i < quantity; i++) {
                          cart.add(widget.product);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added $quantity items to cart'),
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

        if (isWide) {
          // Desktop/Web Layout (Two Columns)
          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: imageSection),
                  const SizedBox(width: 48),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(child: detailsSection),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Mobile Layout (Single Column)
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageSection,
                const SizedBox(height: 24),
                detailsSection,
                const SizedBox(height: 40),
              ],
            ),
          );
        }
      },
    );
  }
}
