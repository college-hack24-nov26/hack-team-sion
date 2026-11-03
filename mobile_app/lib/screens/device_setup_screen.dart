import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import 'welcome_auth_screen.dart';
import 'parent_dashboard_screen.dart';
import 'pairing_screen.dart';
import 'child_shield_screen.dart';

class DeviceSetupScreen extends StatelessWidget {
  const DeviceSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Brand Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [RakshanTheme.primaryBlue, RakshanTheme.secondaryCyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: RakshanTheme.primaryBlue.withValues(alpha: 0.35),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 44),
              ),
              const SizedBox(height: 18),

              const Text(
                'Rakshan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  color: RakshanTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Family Cyber Safety & Parental Protection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: RakshanTheme.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how this phone will be set up:',
                style: TextStyle(
                  fontSize: 13,
                  color: RakshanTheme.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),

              // Option 1: Parent Device
              _DeviceRoleCard(
                title: 'This is a Parent Device',
                subtitle: 'Monitor child activity, receive cyber hazard alerts, and manage screen time & app blockers remotely.',
                icon: Icons.family_restroom_rounded,
                accentColor: RakshanTheme.primaryBlue,
                tag: 'PARENT PORTAL',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApiService.currentUser != null
                          ? const ParentDashboardScreen()
                          : const WelcomeAuthScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Option 2: Child Device
              _DeviceRoleCard(
                title: 'This is a Child\'s Phone',
                subtitle: 'Pair this device with Parent code (or QR) to enable automatic cyberbullying and predator protection.',
                icon: Icons.phone_android_rounded,
                accentColor: RakshanTheme.safeGreen,
                tag: 'CHILD SHIELD',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PairingScreen(isParentView: false),
                    ),
                  );
                },
              ),
              const Spacer(flex: 3),

              // Simple friendly footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline_rounded, size: 14, color: RakshanTheme.textMuted),
                  SizedBox(width: 6),
                  Text(
                    'Private & Secure • Connected via Production Gateway',
                    style: TextStyle(fontSize: 11, color: RakshanTheme.textMuted, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceRoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String tag;
  final VoidCallback onTap;

  const _DeviceRoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accentColor.withValues(alpha: 0.35), width: 1.6),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: accentColor, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: RakshanTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: RakshanTheme.textMuted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: accentColor, size: 16),
          ],
        ),
      ),
    );
  }
}
