import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import 'parent_dashboard_screen.dart';
import 'child_shield_screen.dart';
import 'pairing_screen.dart';

class WelcomeAuthScreen extends StatefulWidget {
  const WelcomeAuthScreen({super.key});

  @override
  State<WelcomeAuthScreen> createState() => _WelcomeAuthScreenState();
}

class _WelcomeAuthScreenState extends State<WelcomeAuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Rajesh Sharma');
  final _emailController = TextEditingController(text: 'parent@rakshan.ai');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _passwordController = TextEditingController(text: 'password123');

  Future<void> _submitParentAuth() async {
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
            content: Text('Account created successfully! Welcome to Rakshan.'),
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

  void _autofillDemoParent() {
    setState(() {
      _isLogin = true;
      _emailController.text = 'parent@rakshan.ai';
      _passwordController.text = 'password123';
    });
    _submitParentAuth();
  }

  void _showTwoDeviceTestingGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.devices_rounded, color: RakshanTheme.primaryBlue, size: 26),
                    SizedBox(width: 10),
                    Text(
                      '2-Device Live Testing Guide',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: RakshanTheme.textPrimary),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: RakshanTheme.textMuted),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'How to test real-time communication between 2 phones via Ngrok:',
              style: TextStyle(color: RakshanTheme.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 18),
            _buildGuideStep(
              stepNumber: '1',
              title: 'On Phone 1 (Parent Device)',
              description: 'Tap "1-Tap Demo Login" to enter the Parent Portal. Tap the QR icon or "Pair Device" to get your live 6-digit code (e.g. 535830).',
            ),
            const SizedBox(height: 14),
            _buildGuideStep(
              stepNumber: '2',
              title: 'On Phone 2 (Child Device)',
              description: 'Open Rakshan app on Phone 2 and tap "Set up this phone as Child Phone". Enter the 6-digit code shown on Phone 1 and tap "Activate Shield".',
            ),
            const SizedBox(height: 14),
            _buildGuideStep(
              stepNumber: '3',
              title: 'Test Live Cyber Threat Detection',
              description: 'On Phone 2, tap "Simulate Threat Message" or "Emergency SOS". Watch Phone 1 immediately receive the alert, update the Risk Gauge, and log the incident in real-time!',
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RakshanTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Got it! Start Testing', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildGuideStep({required String stepNumber, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: RakshanTheme.primaryLight,
            shape: BoxShape.circle,
            border: Border.all(color: RakshanTheme.primaryBlue.withOpacity(0.3)),
          ),
          alignment: Alignment.center,
          child: Text(stepNumber, style: const TextStyle(color: RakshanTheme.primaryBlue, fontWeight: FontWeight.w900, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: RakshanTheme.textPrimary)),
              const SizedBox(height: 3),
              Text(description, style: const TextStyle(color: RakshanTheme.textMuted, fontSize: 12, height: 1.35)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Clean Friendly Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [RakshanTheme.primaryBlue, RakshanTheme.secondaryCyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: RakshanTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.shield_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Rakshan',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: RakshanTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Child Cyber Safety & Family Shield',
                          style: TextStyle(
                            color: RakshanTheme.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2-Device Testing Guide Banner
                GestureDetector(
                  onTap: _showTwoDeviceTestingGuide,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: RakshanTheme.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: RakshanTheme.primaryBlue.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.help_outline_rounded, color: RakshanTheme.primaryBlue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Testing with 2 Devices? Tap for step-by-step guide',
                            style: TextStyle(
                              color: RakshanTheme.primaryBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, color: RakshanTheme.primaryBlue, size: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Main Parent Auth Card
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
                        // Toggle: Sign In vs Register
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
                                      'Parent Sign In',
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
                                      'Create Account',
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
                        const SizedBox(height: 18),

                        if (!_isLogin) ...[
                          const Text('YOUR NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: RakshanTheme.textMuted)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: RakshanTheme.textPrimary),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person_outline_rounded, color: RakshanTheme.primaryBlue, size: 20),
                              hintText: 'e.g. Rajesh Sharma',
                            ),
                            validator: (v) => v!.trim().isEmpty ? 'Please enter your name' : null,
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
                          validator: (v) => v!.trim().isEmpty ? 'Please enter your email' : null,
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

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: RakshanTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _isLoading ? null : _submitParentAuth,
                            child: _isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : Text(_isLogin ? 'Sign In as Parent' : 'Create Guardian Account', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 1-Tap Demo Login Button for Presentations & Instant Access
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.bolt_rounded, color: RakshanTheme.primaryBlue, size: 18),
                            label: const Text('⚡ One-Tap Demo Parent (Rajesh Sharma)', style: TextStyle(color: RakshanTheme.primaryBlue, fontWeight: FontWeight.w800, fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: RakshanTheme.primaryBlue.withOpacity(0.35)),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _isLoading ? null : _autofillDemoParent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Direct Child Device Onboarding Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: RakshanTheme.safeGreen.withOpacity(0.35)),
                    boxShadow: [
                      BoxShadow(
                        color: RakshanTheme.safeGreen.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: RakshanTheme.safeGreenLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.phone_android_rounded, color: RakshanTheme.safeGreen, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Setting up Child\'s Phone?',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                color: RakshanTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Pair this device with Parent using 6-digit code',
                              style: TextStyle(color: RakshanTheme.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RakshanTheme.safeGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChildShieldScreen()),
                          );
                        },
                        child: const Text('Pair Device', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
