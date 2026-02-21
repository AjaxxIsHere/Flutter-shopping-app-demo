import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cart_site/providers/auth_provider.dart';
import 'package:cart_site/shared_widgets/auth_form_field.dart';
import 'package:cart_site/shared_widgets/auth_button.dart';

// Register screen allowing users to enter their credentials and create a new account
// Widgets: - AuthFormField: custom widget for input fields with validation
//          - AuthButton: custom widget for the register button with loading state
// Logic: - On form submission, calls the register method from AuthProvider and handles success or failure cases with appropriate UI feedback (navigation to login on success, error message on failure)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(_username.text.trim(), _password.text.trim());

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created — please log in')));
      Navigator.pop(context);
    } else {
      final message = auth.error ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
              Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Username Field
                AuthFormField(
                  label: 'Username',
                  prefixIcon: Icons.person_outline,
                  controller: _username,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter username' : null,
                ),
                const SizedBox(height: 16),
                // Password Field
                AuthFormField(
                  label: 'Password',
                  prefixIcon: Icons.lock_outline,
                  controller: _password,
                  obscureText: true,
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
                ),
                const SizedBox(height: 16),
                AuthFormField(
                  label: 'Repeat Password',
                  prefixIcon: Icons.lock_outline,
                  controller: _password,
                  helperText: 'Use 8 or more characters',
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter password';
                    if (v != _password.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Create Account Button
                AuthButton(
                  label: 'Create Account',
                  icon: auth.isLoading ? null : Icons.person_add_rounded,
                  onPressed: _submit,
                  isLoading: auth.isLoading,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 20),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Sign in',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
