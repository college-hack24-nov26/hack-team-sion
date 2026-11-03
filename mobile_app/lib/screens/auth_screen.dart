import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import 'parent_dashboard_screen.dart';
import 'child_shield_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Rajesh Sharma');
  final _emailController = TextEditingController(text: 'parent@rakshan.ai');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _passwordController = TextEditingController(text: 'password123');

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (_isLogin) {
      final res = await ApiService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (res['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ParentDashboardScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: RakshanTheme.criticalRed,
            content: Text(res['error'] ?? 'Login failed. Please check credentials.'),
          ),
        );
      }
    } else {
      final res = await ApiService.register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (res['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: RakshanTheme.safeGreen,
            content: Text('Account created successfully! Welcome to Rakshan AI.'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ParentDashboardScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: RakshanTheme.criticalRed,
            content: Text(res['error'] ?? 'Registration failed.'),
          ),
        );
      }
    }
  }

  void _autofillDemo() {
    setState(() {
      _isLogin = true;
      _emailController.text = 'parent@rakshan.ai';
      _passwordController.text = 'password123';
    });
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Brand Header
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [RakshanTheme.primaryBlue, RakshanTheme.secondaryCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: RakshanTheme.primaryBlue.withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 14),
                const Text(
                  'RAKSHAN AI',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: RakshanTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Child Cyber-Safety, Risk Intelligence & Parental Shield',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: RakshanTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                // Main Auth Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: RakshanTheme.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tab Selector
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: RakshanTheme.surfaceMuted,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isLogin = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _isLogin ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: _isLogin
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF0F172A).withOpacity(0.04),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Parent Login',
                                      style: TextStyle(
                                        color: _isLogin ? RakshanTheme.primaryBlue : RakshanTheme.textMuted,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isLogin = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: !_isLogin ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: !_isLogin
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF0F172A).withOpacity(0.04),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Register Guardian',
                                      style: TextStyle(
                                        color: !_isLogin ? RakshanTheme.primaryBlue : RakshanTheme.textMuted,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form Fields
                        if (!_isLogin) ...[
                          const Text('FULL NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: RakshanTheme.textMuted)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: RakshanTheme.textPrimary),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline_rounded, color: RakshanTheme.primaryBlue, size: 20),
                              hintText: 'e.g. Rajesh Sharma',
                            ),
                            validator: (v) => v!.trim().isEmpty ? 'Please enter your full name' : null,
                          ),
                          const SizedBox(height: 14),
                          const Text('PHONE NUMBER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: RakshanTheme.textMuted)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: RakshanTheme.textPrimary),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone_outlined, color: RakshanTheme.primaryBlue, size: 20),
                              hintText: '+91 98765 43210',
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        const Text('EMAIL ADDRESS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: RakshanTheme.textMuted)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: RakshanTheme.textPrimary),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: RakshanTheme.primaryBlue, size: 20),
                            hintText: 'parent@rakshan.ai',
                          ),
                          validator: (v) => v!.trim().isEmpty ? 'Please enter a valid email' : null,
                        ),
                        const SizedBox(height: 14),

                        const Text('PASSWORD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: RakshanTheme.textMuted)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: RakshanTheme.textPrimary),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: RakshanTheme.primaryBlue, size: 20),
                            hintText: '••••••••',
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) => v!.length < 6 ? 'Password must be at least 6 characters' : null,
                        ),
                        const SizedBox(height: 20),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RakshanTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Text(_isLogin ? 'Sign In to Portal' : 'Create Account', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Quick 1-Tap Demo Login Button for Presentations
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.bolt_rounded, color: RakshanTheme.accentRose, size: 18),
                            label: const Text('⚡ Quick Auto-Fill Demo Parent', style: TextStyle(color: RakshanTheme.accentRose, fontWeight: FontWeight.w800, fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: RakshanTheme.accentRose.withOpacity(0.4)),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _isLoading ? null : _autofillDemo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Switch to Child Device Setup
                TextButton.icon(
                  icon: const Icon(Icons.phonelink_setup_rounded, color: RakshanTheme.safeGreen, size: 18),
                  label: const Text(
                    'Setting up Child Device instead? Tap Here',
                    style: TextStyle(color: RakshanTheme.safeGreen, fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChildShieldScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8),

                const Text(
                  'DPDP Act 2023 §9 Protocol • POCSO Act 2012 Compliance Support',
                  style: TextStyle(color: RakshanTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
