import 'package:flutter/material.dart';

// Star rater widget that displays a star icon along with the product rating, used in the product card to visually represent the rating of a product
// Widgets: - Icon: star icon colored amber to indicate rating visually
//          - Text: displays the numerical rating value next to the star icon, formatted to one decimal place for consistency
class StarRater extends StatelessWidget {
  final double rating;
  final double iconSize;
  final TextStyle? textStyle;

  const StarRater({super.key, required this.rating, this.iconSize = 16, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ?? Theme.of(context).textTheme.bodySmall;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: iconSize, color: Colors.amber),
        const SizedBox(width: 6),
        Text(rating.toStringAsFixed(1), style: ts),
      ],
    );
  }
}
