import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cart_site/shared_widgets/checkout_card.dart';
import 'package:cart_site/providers/cart_provider.dart';


// Cart screen displaying the items added to the cart and allowing users to proceed to checkout
// Widgets: - _buildEmptyState: shows a message when the cart is empty
//          - _buildMobileCartItem: renders a single cart item in the mobile layout
//          - _buildDesktopCartItem: renders a single cart item in the desktop layout
//          - _buildMobileCheckoutFooter: fixed footer for mobile showing total and checkout button
//          - _buildDesktopOrderSummary: sidebar for desktop showing order summary and checkout button
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isDesktop
          ? _buildDesktopLayout(context, cart)
          : _buildMobileLayout(context, cart),
    );
  }

  Widget _buildMobileLayout(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        Expanded(
          child: cart.items.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) =>
                      _buildMobileCartItem(context, cart, index),
                ),
        ),
        _buildMobileCheckoutFooter(context, cart),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: cart.items.isEmpty
                ? _buildEmptyState(context)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items (${cart.items.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) =>
                              _buildDesktopCartItem(context, cart, index),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(
            width: 360,
            child: _buildDesktopOrderSummary(context, cart),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCartItem(BuildContext context, CartProvider cart, int index) {
    final item = cart.items[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Image.network(
                  item.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () => cart.remove(item),
              tooltip: 'Remove from cart',
              constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopCartItem(BuildContext context, CartProvider cart, int index) {
    final item = cart.items[index];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Image.network(
                    item.image,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 140,
                        height: 140,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () => cart.remove(item),
                tooltip: 'Remove from cart',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCheckoutFooter(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${cart.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
          onPressed: cart.items.isEmpty
              ? null
              : () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => CheckoutCard(totalAmount: cart.total),
            );
            if (result == true && context.mounted) {
              cart.clear();
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            backgroundColor: Theme.of(context).colorScheme.primary,
            disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Proceed to Checkout',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildDesktopOrderSummary(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Order Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSummaryRow(
                  context,
                  'Items',
                  '${cart.items.length}',
                ),
                const SizedBox(height: 12),
                Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  height: 16,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  context,
                  'Subtotal',
                  '\$${cart.total.toStringAsFixed(2)}',
                  isHighlight: false,
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  context,
                  'Shipping',
                  'Free',
                  isHighlight: false,
                ),
                const SizedBox(height: 12),
                Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  height: 16,
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  context,
                  'Total',
                  '\$${cart.total.toStringAsFixed(2)}',
                  isHighlight: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: cart.items.isEmpty
              ? null
              : () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => CheckoutCard(totalAmount: cart.total),
            );
            if (result == true && context.mounted) {
              cart.clear();
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            backgroundColor: Theme.of(context).colorScheme.primary,
            disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Proceed to Checkout',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isHighlight
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isHighlight
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
