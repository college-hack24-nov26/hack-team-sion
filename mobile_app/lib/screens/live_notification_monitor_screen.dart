import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';

class LiveNotificationMonitorScreen extends StatefulWidget {
  const LiveNotificationMonitorScreen({super.key});

  @override
  State<LiveNotificationMonitorScreen> createState() => _LiveNotificationMonitorScreenState();
}

class _LiveNotificationMonitorScreenState extends State<LiveNotificationMonitorScreen> {
  bool _hasPermission = false;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    ApiService.initNativeInterception();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    setState(() => _isCheckingPermission = true);
    final granted = await ApiService.checkNotificationPermission();
    if (mounted) {
      setState(() {
        _hasPermission = granted;
        _isCheckingPermission = false;
      });
    }
  }

  Future<void> _openPermissionSettings() async {
    await ApiService.requestNotificationPermission();
    await Future.delayed(const Duration(seconds: 1));
    _checkPermission();
  }

  Future<void> _triggerTestNotification({
    required String appName,
    required String title,
    required String message,
  }) async {
    final success = await ApiService.sendLocalTestNotification(
      appName: appName,
      title: title,
      message: message,
    );

    if (!success) {
      // If local notification failed, directly ingest via AI backend
      final eval = await ApiService.ingestChildActivity(
        textContent: message,
        appName: appName,
        sender: title,
      );
      final simulatedPayload = {
        'package_name': 'simulated.$appName',
        'app_name': appName,
        'sender': title,
        'text_content': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'ai_eval': eval,
      };
      ApiService.liveNotificationLogs.value = [simulatedPayload, ...ApiService.liveNotificationLogs.value];
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: RakshanTheme.primaryBlue,
          content: Text('⚡ Dispatched $appName notification! AI Model scoring in real-time...'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

    void _showGeminiKeyDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.auto_awesome_rounded, color: RakshanTheme.accentPurple, size: 24),
            SizedBox(width: 10),
            Text('Gemini AI Intelligence', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste your Google Gemini API Key below to enable deep semantic LLM reasoning for subtle, disguised, or violent cyber threats.',
              style: TextStyle(fontSize: 12, color: RakshanTheme.textMuted, height: 1.4),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'AIzaSy...',
                labelText: 'Gemini API Key',
                filled: true,
                fillColor: RakshanTheme.surfaceMuted,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RakshanTheme.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              final key = controller.text.trim();
              if (key.isNotEmpty) {
                await ApiService.setGeminiApiKey(key);
                if (mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: RakshanTheme.safeGreen,
                      content: Text('✓ Gemini AI Model Active for Real-Time Threat Analysis!'),
                    ),
                  );
                }
              }
            },
            child: const Text('Save & Activate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      appBar: AppBar(
        title: const Text('Real-Time Notification Shield'),
        actions: [
          IconButton(
            tooltip: 'Configure Gemini AI Key',
            icon: const Icon(Icons.auto_awesome_rounded, color: RakshanTheme.accentPurple),
            onPressed: _showGeminiKeyDialog,
          ),
          IconButton(
            tooltip: 'Refresh Status',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _checkPermission,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Live Status Header Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _hasPermission ? RakshanTheme.safeGreen : RakshanTheme.highOrange,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_hasPermission ? RakshanTheme.safeGreen : RakshanTheme.highOrange).withOpacity(0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _hasPermission ? RakshanTheme.safeGreenLight : const Color(0xFFFFF7ED),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _hasPermission ? Icons.notifications_active_rounded : Icons.notification_important_rounded,
                          color: _hasPermission ? RakshanTheme.safeGreen : RakshanTheme.highOrange,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hasPermission
                                  ? '● LIVE NOTIFICATION LISTENER ACTIVE'
                                  : 'PERMISSION REQUIRED',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: _hasPermission ? RakshanTheme.safeGreen : RakshanTheme.highOrange,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              _hasPermission
                                  ? 'Real-time Android background hook enabled'
                                  : 'Allow Rakshan to scan WhatsApp, Instagram & DMs',
                              style: const TextStyle(fontSize: 11, color: RakshanTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!_hasPermission) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RakshanTheme.highOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.settings_suggest_rounded, size: 18),
                        label: const Text('Enable Android Notification Access', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                        onPressed: _openPermissionSettings,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Real-Time Test Dispatcher Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚡ TEST REAL-TIME PHONE NOTIFICATION & AI SCORING',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: RakshanTheme.textMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _TestPayloadChip(
                          label: '🚨 Grooming Probe',
                          app: 'Instagram DM',
                          color: RakshanTheme.criticalRed,
                          onTap: () => _triggerTestNotification(
                            appName: 'Instagram DM',
                            title: 'alex_stranger',
                            message: "Don't tell your mom about our chat. She doesn't understand you, send me a private selfie now.",
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TestPayloadChip(
                          label: '🚨 Hinglish Extortion',
                          app: 'WhatsApp',
                          color: RakshanTheme.criticalRed,
                          onTap: () => _triggerTestNotification(
                            appName: 'WhatsApp',
                            title: '+91 98231 00982',
                            message: "Teri photos viral kar dunga agar 2000 rupaye nahi diye toh. Mummy papa ko mat bolna!",
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TestPayloadChip(
                          label: '🚨 Cyberbullying',
                          app: 'Discord',
                          color: RakshanTheme.highOrange,
                          onTap: () => _triggerTestNotification(
                            appName: 'Discord',
                            title: 'ToxicGroup#82',
                            message: "You are a total loser, nobody likes you here. Go die!",
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TestPayloadChip(
                          label: '🛡️ Benign Safe Message',
                          app: 'Family Chat',
                          color: RakshanTheme.safeGreen,
                          onTap: () => _triggerTestNotification(
                            appName: 'WhatsApp',
                            title: 'Mom (Family)',
                            message: "Beta dinner is ready at 8 PM, please finish your homework on time.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Live Notification Feed Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LIVE INTERCEPTED FEED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: RakshanTheme.textMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                  ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: ApiService.liveNotificationLogs,
                    builder: (_, logs, __) => Text(
                      '${logs.length} Event(s) Captured',
                      style: const TextStyle(fontSize: 11, color: RakshanTheme.primaryBlue, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Notification Feed List
            Expanded(
              child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: ApiService.liveNotificationLogs,
                builder: (context, logs, _) {
                  if (logs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shield_outlined, size: 48, color: RakshanTheme.textMuted),
                          SizedBox(height: 12),
                          Text(
                            'Waiting for incoming notifications...',
                            style: TextStyle(fontWeight: FontWeight.w700, color: RakshanTheme.textMuted),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Any WhatsApp, Instagram, or SMS notification on this phone\nwill be instantly analyzed by AI models.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: RakshanTheme.textMuted),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: logs.length,
                    itemBuilder: (ctx, i) {
                      final item = logs[i];
                      final eval = item['ai_eval'] as Map<String, dynamic>? ?? {};
                      final double score = (eval['overall_risk_score'] as num?)?.toDouble() ?? 0.0;
                      final String severity = eval['severity'] ?? (score >= 85 ? 'CRITICAL' : (score >= 70 ? 'HIGH' : (score >= 35 ? 'MEDIUM' : 'SAFE')));
                      final Color scoreColor = RakshanTheme.getRiskColor(score);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: score >= 70 ? scoreColor.withOpacity(0.5) : RakshanTheme.cardBorder,
                            width: score >= 70 ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // App Header & Risk Score Pill
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: RakshanTheme.primaryLight,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item['app_name'] ?? 'App',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 11,
                                            color: RakshanTheme.primaryBlue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'From: ${item['sender'] ?? 'Unknown'}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: RakshanTheme.textPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: scoreColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: scoreColor.withOpacity(0.4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'AI RISK: ${score.toStringAsFixed(0)}/100',
                                        style: TextStyle(
                                          color: scoreColor,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '($severity)',
                                        style: TextStyle(
                                          color: scoreColor,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Notification Text
                            Text(
                              item['text_content'] ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.35,
                                color: RakshanTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // AI Harm Cues
                            if (eval['detected_reason'] != null) ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: score >= 70 ? RakshanTheme.criticalRedLight : RakshanTheme.surfaceMuted,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      score >= 70 ? Icons.gavel_rounded : Icons.info_outline_rounded,
                                      size: 15,
                                      color: score >= 70 ? RakshanTheme.criticalRed : RakshanTheme.textMuted,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        eval['detected_reason'] ?? '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: score >= 70 ? RakshanTheme.criticalRed : RakshanTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestPayloadChip extends StatelessWidget {
  final String label;
  final String app;
  final Color color;
  final VoidCallback onTap;

  const _TestPayloadChip({
    required this.label,
    required this.app,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w800)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(app, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

