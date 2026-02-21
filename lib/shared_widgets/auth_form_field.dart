import 'package:flutter/material.dart';

// Custom form field widget used in authentication screens (login and register) with built-in validation and styling
// Fields: - label: text to display as the field's label
//         - prefixIcon: icon to display at the beginning of the field
//         - controller: TextEditingController to manage the input text
//         - validator: optional function to validate the input value
//         - obscureText: indicates if the input should be obscured (e.g., for password fields)
//         - helperText: optional text to display below the field for additional guidance
class AuthFormField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? helperText;

  const AuthFormField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        helperText: helperText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
