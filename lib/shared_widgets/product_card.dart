import 'package:flutter/material.dart';
import '../models/products_model.dart';
import 'package:cart_site/shared_widgets/star_rater.dart';

// Product card widget used to display individual product information in a card format, including image, title, rating, price, and an add to cart button
// Widgets: - Hero: for smooth image transition to product details screen
//          - StarRater: custom widget to visually represent the product rating with stars
//          - IconButton: for adding the product to the cart with a shopping cart icon
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const ProductCard({super.key, required this.product, this.onTap, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Slight elevation for depth
      color: Theme.of(context).colorScheme.surfaceContainer, // M3 surface color
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // More rounded
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.white, // White background for product images to pop
                padding: const EdgeInsets.all(16.0),
                child: Hero(
                  tag: 'product_${product.id}',
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StarRater(rating: product.rating, iconSize: 16, textStyle: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 6),
                          Text('\$${product.price}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.green)),
                        ],
                      ),
                      IconButton(
                        onPressed: onAdd,
                        icon: const Icon(Icons.add_shopping_cart),
                        tooltip: 'Add to cart',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
