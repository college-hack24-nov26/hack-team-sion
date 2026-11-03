import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import 'auth_screen.dart';
import 'parent_dashboard_screen.dart';
import 'child_shield_screen.dart';
import 'live_detection_demo_screen.dart';
import 'live_notification_monitor_screen.dart';
import 'suspicious_games_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Brand Icon & Logo
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
                child: const Icon(
                  Icons.shield_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),
              const SizedBox(height: 14),

              const Text(
                'RAKSHAN AI',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: RakshanTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Real-Time Child Cyber Safety, Notification Scoring & Game Intel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: RakshanTheme.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // Compliance Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: RakshanTheme.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RakshanTheme.primaryBlue.withOpacity(0.25)),
                ),
                child: const Text(
                  'REAL-TIME NOTIFICATION HOOK • NEWS THREAT INTEL • DPDP ACT 2023',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: RakshanTheme.primaryBlue,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // FEATURE 1: Real-Time Notification Interceptor
              _HighlightRoleCard(
                title: '🔔 Real-Time Notification Monitor',
                subtitle: 'Intercept incoming WhatsApp, Instagram & SMS notifications live on this phone with immediate AI Risk Scoring.',
                icon: Icons.notifications_active_rounded,
                accentColor: RakshanTheme.criticalRed,
                isRecommended: true,
                badgeText: 'REAL-TIME AI HOOK',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LiveNotificationMonitorScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

              // FEATURE 2: Suspicious Games Detector
              _HighlightRoleCard(
                title: '🎮 Suspicious Games & News Detector',
                subtitle: 'Scan installed games against previous news history (Free Fire, Blue Whale, Roblox, Underage Gambling debt cases).',
                icon: Icons.sports_esports_rounded,
                accentColor: RakshanTheme.highOrange,
                isRecommended: true,
                badgeText: 'NEWS THREAT INTEL',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SuspiciousGamesScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Role Card: Parent Portal
              _HighlightRoleCard(
                title: 'Parent / Guardian Portal',
                subtitle: 'Monitor real-time risk index, receive high-threat alerts, and enforce remote device & internet locks.',
                icon: Icons.family_restroom_rounded,
                accentColor: RakshanTheme.primaryBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApiService.currentUser != null
                          ? const ParentDashboardScreen()
                          : const AuthScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Role Card: Child Shield Device
              _HighlightRoleCard(
                title: 'Child Shield Device',
                subtitle: 'Background cyber interceptor running on child device with one-tap Emergency SOS Beacon.',
                icon: Icons.security_rounded,
                accentColor: RakshanTheme.safeGreen,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChildShieldScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Role Card: Live Threat Lab
              _HighlightRoleCard(
                title: '⚡ Multi-Agent Threat Studio',
                subtitle: 'Direct playground to test custom sentences and see multi-agent supervisor validation step-by-step.',
                icon: Icons.psychology_rounded,
                accentColor: RakshanTheme.accentPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LiveDetectionDemoScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline_rounded, size: 14, color: RakshanTheme.textMuted),
                  SizedBox(width: 6),
                  Text(
                    'Protected by End-to-End Cryptographic Evidence Vault',
                    style: TextStyle(fontSize: 11, color: RakshanTheme.textMuted, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightRoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isRecommended;
  final String? badgeText;
  final VoidCallback onTap;

  const _HighlightRoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.isRecommended = false,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRecommended ? accentColor.withOpacity(0.5) : RakshanTheme.cardBorder,
            width: isRecommended ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isRecommended
                  ? accentColor.withOpacity(0.08)
                  : const Color(0xFF0F172A).withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: RakshanTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: RakshanTheme.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: RakshanTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
