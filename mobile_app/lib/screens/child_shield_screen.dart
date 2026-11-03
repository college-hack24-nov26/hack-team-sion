import 'live_notification_monitor_screen.dart';
import 'suspicious_games_screen.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import 'pairing_screen.dart';
import 'live_detection_demo_screen.dart';

class ChildShieldScreen extends StatefulWidget {
  const ChildShieldScreen({super.key});

  @override
  State<ChildShieldScreen> createState() => _ChildShieldScreenState();
}

class _ChildShieldScreenState extends State<ChildShieldScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  bool _isSosActive = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _triggerEmergencySos() {
    setState(() => _isSosActive = true);
    final sos = ApiService.triggerChildEmergencySOS();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: const [
            Icon(Icons.emergency_rounded, color: RakshanTheme.criticalRed, size: 28),
            SizedBox(width: 10),
            Text('SOS Alert Dispatched!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'High-priority Emergency Beacon sent directly to Parent Guardian:\n• Rajesh Sharma (+91 98765 43210)',
              style: TextStyle(fontSize: 13, height: 1.4, color: RakshanTheme.textPrimary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RakshanTheme.criticalRedLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: RakshanTheme.criticalRed.withOpacity(0.3)),
              ),
              child: const Text(
                'Location coordinates & live device audio beacon flagged under POCSO & DPDP Emergency Protocols.',
                style: TextStyle(fontSize: 11, color: RakshanTheme.criticalRed, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RakshanTheme.criticalRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _isSosActive = false);
            },
            child: const Text('OK, Guardian Notified'),
          ),
        ],
      ),
    );
  }

  void _showSendTestChatDialog() {
    final textController = TextEditingController(
      text: "Don't tell your mom about our chat. She doesn't understand you, send me a private selfie now.",
    );
    bool isSending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Send Test Cyber Chat Payload',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: RakshanTheme.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: RakshanTheme.textMuted),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Text(
                'This simulates an incoming message arriving on this phone, which is scanned by Rakshan Shield and transmitted to the Parent Device via Ngrok.',
                style: TextStyle(color: RakshanTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Grooming Probe', style: TextStyle(fontSize: 11)),
                    onPressed: () => setModalState(() {
                      textController.text = "Don't tell your mom about this chat. Send me a private selfie.";
                    }),
                  ),
                  ActionChip(
                    label: const Text('Cyberbullying', style: TextStyle(fontSize: 11)),
                    onPressed: () => setModalState(() {
                      textController.text = "You are a total loser, go die nobody likes you.";
                    }),
                  ),
                  ActionChip(
                    label: const Text('Hinglish Extortion', style: TextStyle(fontSize: 11)),
                    onPressed: () => setModalState(() {
                      textController.text = "Teri photo viral kar dunga agar 2000 rupaye nahi diye toh!";
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 3,
                style: const TextStyle(fontWeight: FontWeight.w600, color: RakshanTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Type or pick simulated chat...',
                  filled: true,
                  fillColor: RakshanTheme.surfaceMuted,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: isSending
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(isSending ? 'Sending to Parent...' : 'Transmit Threat to Parent Phone'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RakshanTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: isSending
                      ? null
                      : () async {
                          if (textController.text.trim().isEmpty) return;
                          setModalState(() => isSending = true);
                          await ApiService.ingestChildActivity(
                            textContent: textController.text.trim(),
                            appName: 'Instagram DM',
                          );
                          setModalState(() => isSending = false);
                          if (!mounted) return;
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: RakshanTheme.safeGreen,
                              content: Text('✓ Chat processed! Check Parent Device — Alert and Risk Score updated!'),
                            ),
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      appBar: AppBar(
        title: const Text('Child Shield Protection'),
        actions: [
          IconButton(
            tooltip: 'Live Threat Simulator',
            icon: const Icon(Icons.psychology_rounded, color: RakshanTheme.primaryBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveDetectionDemoScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Animated Shield Graphic
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RakshanTheme.safeGreenLight,
                    border: Border.all(color: RakshanTheme.safeGreen, width: 2.2),
                    boxShadow: [
                      BoxShadow(
                        color: RakshanTheme.safeGreen.withOpacity(0.2),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.verified_user_rounded,
                    color: RakshanTheme.safeGreen,
                    size: 56,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Rakshan Shield Active',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: RakshanTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: RakshanTheme.safeGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Real-Time Background Cyber Interceptor Running',
                    style: TextStyle(
                      color: RakshanTheme.safeGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Guardian Binding Info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: RakshanTheme.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: RakshanTheme.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.link_rounded, color: RakshanTheme.primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Linked Guardian',
                            style: TextStyle(color: RakshanTheme.textMuted, fontSize: 11),
                          ),
                          Text(
                            'Rajesh Sharma (Parent)',
                            style: TextStyle(
                              color: RakshanTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: RakshanTheme.safeGreenLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'SECURE',
                        style: TextStyle(
                          color: RakshanTheme.safeGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Direct Navigation to Real-Time Notification & Game Detectors
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LiveNotificationMonitorScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: RakshanTheme.criticalRed.withOpacity(0.4), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: RakshanTheme.criticalRed.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.notifications_active_rounded, color: RakshanTheme.criticalRed, size: 24),
                            SizedBox(height: 8),
                            Text('Live Notifications', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: RakshanTheme.textPrimary)),
                            SizedBox(height: 2),
                            Text('Real-time AI risk score', style: TextStyle(color: RakshanTheme.textMuted, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SuspiciousGamesScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: RakshanTheme.highOrange.withOpacity(0.4), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: RakshanTheme.highOrange.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.sports_esports_rounded, color: RakshanTheme.highOrange, size: 24),
                            SizedBox(height: 8),
                            Text('Suspicious Games', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: RakshanTheme.textPrimary)),
                            SizedBox(height: 2),
                            Text('News history intel', style: TextStyle(color: RakshanTheme.textMuted, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tactile Big Emergency SOS Button
              GestureDetector(
                onTap: _triggerEmergencySos,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: RakshanTheme.criticalRed.withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.emergency_rounded, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EMERGENCY SOS ALERT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            'Tap to immediately alert Parent Guardian',
                            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Threat Interception 2-Device Sender
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RakshanTheme.primaryLight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: RakshanTheme.primaryBlue.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: RakshanTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '2-Device Live Detection Test',
                            style: TextStyle(
                              color: RakshanTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Send a simulated cyber chat to Parent phone via Ngrok.',
                            style: TextStyle(color: RakshanTheme.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RakshanTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _showSendTestChatDialog,
                      child: const Text('Test Send', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Active Android Background Services Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RakshanTheme.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACTIVE ANDROID SYSTEM SHIELD SERVICES',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: RakshanTheme.textMuted,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildServiceItem(
                      icon: Icons.notifications_active_outlined,
                      title: 'Notification Interception Service',
                      subtitle: 'Intercepting WhatsApp, Instagram DM, Discord chats in real-time',
                    ),
                    const Divider(height: 20, color: RakshanTheme.cardBorder),
                    _buildServiceItem(
                      icon: Icons.search_rounded,
                      title: 'Browser & Search Query Scanner',
                      subtitle: 'Monitoring Chrome, YouTube, and Google search queries',
                    ),
                    const Divider(height: 20, color: RakshanTheme.cardBorder),
                    _buildServiceItem(
                      icon: Icons.block_rounded,
                      title: 'Remote App Blocker & Curfew',
                      subtitle: 'Enforcing parent limits on social media & bedtime curfew',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Privacy-by-Design Transparency Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RakshanTheme.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.privacy_tip_outlined, color: RakshanTheme.primaryBlue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Privacy Transparency (DPDP Act 2023)',
                          style: TextStyle(
                            color: RakshanTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Your private family photos and regular messages are NEVER monitored or saved.\n'
                      '• Background micro-agents only inspect predatory coercion, grooming probes, and severe bullying cues.\n'
                      '• All compliance records are hashed with SHA-256 for statutory POCSO child protection.',
                      style: TextStyle(
                        color: RakshanTheme.textMuted,
                        fontSize: 12,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Pair with new code button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.qr_code_rounded, color: RakshanTheme.primaryBlue, size: 18),
                  label: const Text(
                    'Pair with New Guardian Code',
                    style: TextStyle(color: RakshanTheme.primaryBlue, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: RakshanTheme.primaryBlue, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PairingScreen(isParentView: false)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: RakshanTheme.safeGreenLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: RakshanTheme.safeGreen, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: RakshanTheme.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: RakshanTheme.textMuted, fontSize: 11, height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: RakshanTheme.safeGreenLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('RUNNING', style: TextStyle(color: RakshanTheme.safeGreen, fontSize: 10, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}
