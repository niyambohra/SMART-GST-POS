import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/isar/user_model.dart';
import '../../providers/auth_provider.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _identifierController.text.trim(),
      _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Invalid username or password.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleQuickDemoLogin(UserRole role) {
    final auth = context.read<AuthProvider>();
    auth.switchRole(role);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Branding Logo & Title
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.point_of_sale_rounded,
                            size: 48,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'SMART GST Mart',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Offline-First Local POS & GST Billing System',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 28),

                      // Error message banner if any
                      if (auth.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  auth.errorMessage!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email / Phone Field
                      TextFormField(
                        controller: _identifierController,
                        decoration: const InputDecoration(
                          labelText: 'Email or Mobile Number',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your email or phone number'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter your password'
                            : null,
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      FilledButton(
                        onPressed: auth.isLoading ? null : _handleLogin,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Sign In to POS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      const SizedBox(height: 16),

                      // Register First Owner Button
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Setup New Owner Account'),
                      ),
                      const Divider(height: 36),

                      // Quick Demo Access Selector
                      const Text(
                        '⚡ Quick Demo Testing Login:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.shield, size: 14, color: Colors.teal),
                            label: const Text('Owner', style: TextStyle(fontSize: 11)),
                            onPressed: () => _handleQuickDemoLogin(UserRole.owner),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.manage_accounts, size: 14, color: Colors.blue),
                            label: const Text('Manager', style: TextStyle(fontSize: 11)),
                            onPressed: () => _handleQuickDemoLogin(UserRole.manager),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.point_of_sale, size: 14, color: Colors.purple),
                            label: const Text('Cashier', style: TextStyle(fontSize: 11)),
                            onPressed: () => _handleQuickDemoLogin(UserRole.cashier),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
