import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cart_site/providers/auth_provider.dart';
import 'package:cart_site/shared_widgets/auth_form_field.dart';
import 'package:cart_site/shared_widgets/auth_button.dart';

// Login screen allowing users to enter their credentials and authenticate
// Widgets: - AuthFormField: custom widget for input fields with validation
//          - AuthButton: custom widget for the login button with loading state
// Logic: - On form submission, calls the login method from AuthProvider and handles success or failure cases with appropriate UI feedback (navigation on success, error message on failure)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    final success = await auth.login(_username.text.trim(), _password.text.trim());
    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
    } else {
      final message = auth.error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      debugPrint('Login error: ${auth.error}');
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
                Text(
                  'Welcome Back',
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
                const SizedBox(height: 24),
                // Login Button
                AuthButton(
                  label: 'Sign In',
                  icon: auth.isLoading ? null : Icons.login_rounded,
                  onPressed: _submit,
                  isLoading: auth.isLoading,
                ),
                const SizedBox(height: 24),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'New here?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sign Up Link
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  icon: const Icon(Icons.person_add_outlined),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: const Text(
                    'Create an Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
