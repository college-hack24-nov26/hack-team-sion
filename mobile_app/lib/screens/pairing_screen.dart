import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import 'child_shield_screen.dart';

class PairingScreen extends StatefulWidget {
  final bool isParentView;

  const PairingScreen({super.key, this.isParentView = true});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final _childNameController = TextEditingController(text: 'Aarav (Galaxy S23)');
  final _childPhoneController = TextEditingController(text: '+91 98765 43210');
  final _pinController = TextEditingController();

  String _generatedCode = '535830';
  bool _isLoading = false;
  String? _statusMessage;
  bool _usePhoneNumber = false;

  @override
  void initState() {
    super.initState();
    if (widget.isParentView) {
      _generateNewCode();
    }
  }

  Future<void> _generateNewCode() async {
    setState(() => _isLoading = true);
    final res = await ApiService.generatePairingCode(_childNameController.text.trim());
    setState(() {
      _generatedCode = res['code'] ?? '535830';
      _isLoading = false;
    });
  }

  Future<void> _verifyCodeAsChild() async {
    final code = _pinController.text.trim();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit pairing code.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final res = await ApiService.verifyPairingCode(
      code,
      'DEV-CHILD-${DateTime.now().millisecondsSinceEpoch}',
    );

    setState(() {
      _isLoading = false;
      _statusMessage = res['message'] ?? 'Device linked!';
    });

    if (res['success'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: RakshanTheme.safeGreen,
          content: Text('✓ Paired with ${res['parent_name'] ?? 'Parent'}! Child Shield Activated.'),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChildShieldScreen()),
      );
    }
  }

  void _sendInviteViaSms() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          'Pairing link and code $_generatedCode sent to ${_childPhoneController.text} via SMS!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      appBar: AppBar(
        title: Text(widget.isParentView ? 'Connect Child Device' : 'Connect to Parent Phone'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: widget.isParentView ? _buildParentView() : _buildChildView(),
      ),
    );
  }

  Widget _buildParentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),

        // Method Selector Toggle
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
                  onTap: () => setState(() => _usePhoneNumber = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !_usePhoneNumber ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: !_usePhoneNumber
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'QR & 6-Digit Code',
                      style: TextStyle(
                        color: !_usePhoneNumber ? RakshanTheme.primaryBlue : RakshanTheme.textMuted,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _usePhoneNumber = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _usePhoneNumber ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: _usePhoneNumber
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Invite by Phone Number',
                      style: TextStyle(
                        color: _usePhoneNumber ? RakshanTheme.primaryBlue : RakshanTheme.textMuted,
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
        const SizedBox(height: 24),

        if (!_usePhoneNumber) ...[
          // Simulated Clean QR Visual & Code
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: RakshanTheme.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // QR Mock
                Container(
                  width: 130,
                  height: 130,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: RakshanTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RakshanTheme.cardBorder),
                  ),
                  child: Center(
                    child: Icon(Icons.qr_code_2_rounded, size: 100, color: RakshanTheme.textPrimary),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'One-Time Pairing Code',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: RakshanTheme.textMuted),
                ),
                const SizedBox(height: 6),
                Text(
                  _generatedCode,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 10,
                    color: RakshanTheme.primaryBlue,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.timer_outlined, color: RakshanTheme.textMuted, size: 15),
                    SizedBox(width: 6),
                    Text(
                      'Expires in 15 minutes • Single-use',
                      style: TextStyle(color: RakshanTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'On your child\'s phone, open Rakshan, select "This is a Child\'s Phone", and enter the code above.',
            textAlign: TextAlign.center,
            style: TextStyle(color: RakshanTheme.textMuted, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Copy Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RakshanTheme.surfaceMuted,
                    foregroundColor: RakshanTheme.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _generatedCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pairing code copied to clipboard!')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('New Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RakshanTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _generateNewCode,
                ),
              ),
            ],
          ),
        ] else ...[
          // Phone Number Invite Flow
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: RakshanTheme.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Child Phone Number',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: RakshanTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _childPhoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_outlined, color: RakshanTheme.primaryBlue, size: 20),
                    hintText: '+91 98765 43210',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Child Nickname / Device Tag',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: RakshanTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _childNameController,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_outlined, color: RakshanTheme.primaryBlue, size: 20),
                    hintText: 'Aarav (Galaxy S23)',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Send SMS Invite to Child Phone', style: TextStyle(fontWeight: FontWeight.w800)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RakshanTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _sendInviteViaSms,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RakshanTheme.safeGreenLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.phonelink_lock_rounded, color: RakshanTheme.safeGreen, size: 50),
        ),
        const SizedBox(height: 18),
        const Text(
          'Connect to Parent Phone',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: RakshanTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter the 6-digit pairing code shown on your Parent\'s phone to link this device.',
          textAlign: TextAlign.center,
          style: TextStyle(color: RakshanTheme.textMuted, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _pinController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            letterSpacing: 12,
            fontWeight: FontWeight.w900,
            color: RakshanTheme.textPrimary,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '000000',
            hintStyle: TextStyle(color: RakshanTheme.textLight.withValues(alpha: 0.5), letterSpacing: 12),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: RakshanTheme.safeGreen, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: RakshanTheme.cardBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: RakshanTheme.safeGreen, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RakshanTheme.safeGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _isLoading ? null : _verifyCodeAsChild,
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Verify & Activate Shield', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
        if (_statusMessage != null) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: RakshanTheme.safeGreenLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: RakshanTheme.safeGreen.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: RakshanTheme.safeGreen, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _statusMessage!,
                    style: const TextStyle(color: RakshanTheme.safeGreen, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
