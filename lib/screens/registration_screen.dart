// ============================================================
// screens/registration_screen.dart
//
// Screen 1 — Registration
// Collects: Full Name, Email, Gender, Password, Confirm Password
// On success → navigates to Login screen
// ============================================================

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/gender.dart';
import '../validators/app_validator.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Form key — used to trigger validation on all fields at once
  final _formKey = GlobalKey<FormState>();

  // Text controllers — one per input field
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  Gender? _selectedGender;      // nullable until user picks one
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  // Clean up controllers when screen is removed from the tree
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // Called when the user taps "Create Account"
  // ----------------------------------------------------------
  void _submit() {
    // Step 1: validate every field in the form
    if (!_formKey.currentState!.validate()) return;

    // Step 2: validate gender separately (it's a dropdown, not a TextFormField)
    if (_selectedGender == null) {
      _showSnackBar('Please select your gender.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // Step 3: call the controller to register
    final error = AuthController.register(
      fullName: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      gender: _selectedGender!,
    );

    setState(() => _isLoading = false);

    if (error != null) {
      // Registration failed (e.g. duplicate email)
      _showSnackBar(error, isError: true);
      return;
    }

    // Step 4: success — show a message and go to Login
    _showSnackBar('Account created! Please log in.', isError: false);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ----------------------------------------------------------
  // Build
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Header ──────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.person_add,
                            color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Fill in the details below to get started',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Full Name ────────────────────────────────
                CustomTextField(
                  label: 'Full Name',
                  hint: 'e.g. Ali Hassan',
                  controller: _nameController,
                  validator: AppValidator.validateFullName,
                ),

                // ── Email ────────────────────────────────────
                CustomTextField(
                  label: 'Email Address',
                  hint: 'e.g. ali@example.com',
                  controller: _emailController,
                  validator: AppValidator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),

                // ── Gender Dropdown ──────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<Gender>(
                      initialValue: _selectedGender,
                      hint: const Text('Select gender'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      // Build one item per enum value
                      items: Gender.values
                          .map(
                            (g) => DropdownMenuItem(
                              value: g,
                              child: Text(g.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                      validator: (value) =>
                          value == null ? 'Please select your gender' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

                // ── Password ─────────────────────────────────
                CustomTextField(
                  label: 'Password',
                  hint: 'Min 6 chars, 1 uppercase, 1 special char',
                  controller: _passwordController,
                  validator: AppValidator.validatePassword,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                ),

                // Password rules hint box
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Password must have:',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12)),
                      SizedBox(height: 4),
                      _RuleRow(text: 'At least 6 characters'),
                      _RuleRow(text: 'At least 1 uppercase letter (A-Z)'),
                      _RuleRow(text: 'At least 1 special character (!@#\$...)'),
                    ],
                  ),
                ),

                // ── Confirm Password ─────────────────────────
                CustomTextField(
                  label: 'Re-type Password',
                  hint: 'Enter password again',
                  controller: _confirmPasswordController,
                  validator: (value) => AppValidator.validateConfirmPassword(
                      value, _passwordController.text),
                  obscureText: !_showConfirmPassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(
                        () => _showConfirmPassword = !_showConfirmPassword),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Submit Button ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Already have an account? ─────────────────
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text('Already have an account? Log In'),
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

// Small helper widget for password rule rows
class _RuleRow extends StatelessWidget {
  final String text;
  const _RuleRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 14, color: Colors.blue),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
