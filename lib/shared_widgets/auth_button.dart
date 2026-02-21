import 'package:flutter/material.dart';

// Custom button widget used in authentication screens (login and register) with built-in loading state and optional icon support
// Fields: - label: text to display on the button
//         - icon: optional icon to display alongside the label
//         - onPressed: callback function to execute when the button is pressed
//         - isLoading: indicates if the button should show a loading spinner instead of the label
//         - backgroundColor: optional parameter to customize the button's background color
class AuthButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  const AuthButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading ? null : (icon != null ? Icon(icon) : null),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      label: isLoading
          ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
          : Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
    );
  }
}
