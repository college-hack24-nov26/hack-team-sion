import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'device_setup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _activeDot = 0;

  void _onGetStarted() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DeviceSetupScreen()),
    );
  }

  void _showLearnMoreSheet() {
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
                    Icon(Icons.shield_rounded, color: RakshanTheme.primaryBlue, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'About Rakshan Family Shield',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: RakshanTheme.textPrimary),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: RakshanTheme.textMuted),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Rakshan protects your family through intelligent on-device monitoring and parental controls:',
              style: TextStyle(color: RakshanTheme.textMuted, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            _buildFeatureBullet(
              icon: Icons.security_rounded,
              color: RakshanTheme.primaryBlue,
              title: 'Harmful Content & Predator Detection',
              description: 'Real-time classification of grooming, bullying, and coercion without invading private family photos.',
            ),
            const SizedBox(height: 14),
            _buildFeatureBullet(
              icon: Icons.timer_outlined,
              color: RakshanTheme.safeGreen,
              title: 'Screen Time & Curfew Management',
              description: 'Set daily usage limits and lock devices remotely during bedtime or homework hours.',
            ),
            const SizedBox(height: 14),
            _buildFeatureBullet(
              icon: Icons.location_on_outlined,
              color: RakshanTheme.warningAmber,
              title: 'Geofence Safe Zones',
              description: 'Instant parent notification if child departs from designated home or school boundaries.',
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
                onPressed: () {
                  Navigator.pop(ctx);
                  _onGetStarted();
                },
                child: const Text('Get Started with Rakshan', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeatureBullet({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: RakshanTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(description, style: const TextStyle(color: RakshanTheme.textMuted, fontSize: 11.5, height: 1.35)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              // Brand Circular Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/rakshan_logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title: Rakshan
              const Text(
                'Rakshan',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              const Text(
                'Family Cyber Safety &\nParental Protection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 22),

              // Hero Headline: A safer digital world starts here.
              const Text(
                'A safer digital world\nstarts here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  color: Color(0xFF0A1128),
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 10),

              // Body Paragraph
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Protect your children from online threats,\nmanage screen time, and stay informed —\nall from one simple app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Central Family Hero Graphic with connected safety circles
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: Image.asset(
                    'assets/images/family_hero.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Icon(Icons.family_restroom_rounded, size: 80, color: Color(0xFF2563EB)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4 Feature Pillars Row (Exact clone from image)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _FeatureItem(
                    icon: Icons.verified_user_outlined,
                    bgColor: Color(0xFFEFF6FF),
                    iconColor: Color(0xFF2563EB),
                    title: 'Block harmful\ncontent',
                  ),
                  _FeatureItem(
                    icon: Icons.access_time_rounded,
                    bgColor: Color(0xFFECFDF5),
                    iconColor: Color(0xFF10B981),
                    title: 'Manage\nscreen time',
                  ),
                  _FeatureItem(
                    icon: Icons.location_on_outlined,
                    bgColor: Color(0xFFFEF3C7),
                    iconColor: Color(0xFFD97706),
                    title: 'Track\nlocation',
                  ),
                  _FeatureItem(
                    icon: Icons.groups_outlined,
                    bgColor: Color(0xFFF3E8FF),
                    iconColor: Color(0xFF9333EA),
                    title: 'Keep your\nfamily safe',
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Primary Pill Action Button: Get Started →
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.35),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _onGetStarted,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Learn More Link
              GestureDetector(
                onTap: _showLearnMoreSheet,
                child: const Text(
                  'Learn More',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Carousel Page Indicator (Active Blue pill + 2 soft grey dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 14,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
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

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String title;

  const _FeatureItem({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
