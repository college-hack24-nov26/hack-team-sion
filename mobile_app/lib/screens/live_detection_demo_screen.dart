import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import '../widgets/risk_gauge_widget.dart';

class LiveDetectionDemoScreen extends StatefulWidget {
  const LiveDetectionDemoScreen({super.key});

  @override
  State<LiveDetectionDemoScreen> createState() => _LiveDetectionDemoScreenState();
}

class _LiveDetectionDemoScreenState extends State<LiveDetectionDemoScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
  String _scanStep = '';
  Map<String, dynamic>? _analysisResult;
  int _selectedPresetIndex = 0;

  final List<Map<String, String>> _presets = [
    {
      'title': '🚨 Predatory Grooming',
      'app': 'Instagram DM',
      'category': 'Grooming & Coercion',
      'text': "Don't tell your mom about our chat. She doesn't understand you, send me a private selfie now.",
      'description': 'Tests secrecy enforcement ("don\'t tell mom") + intimacy boundary probe ("send selfie").',
    },
    {
      'title': '🚨 Cyberbullying & Harassment',
      'app': 'Discord Chat',
      'category': 'Cyberbullying',
      'text': "You are such a loser, nobody likes you in this group. Go die, everyone hates you!",
      'description': 'Tests severe degradation ("loser") and severe harassment phrases ("go die").',
    },
    {
      'title': '🚨 Hinglish Extortion & Blackmail',
      'app': 'WhatsApp',
      'category': 'Vernacular Extortion',
      'text': "Teri photos viral kar dunga agar 2000 rupaye nahi diye toh. Mummy papa ko mat bolna!",
      'description': 'Tests Hinglish blackmail ("viral kar dunga"), extortion ("paise de"), and secrecy cues.',
    },
    {
      'title': '🚨 Gaming Account Coercion',
      'app': 'Roblox Chat',
      'category': 'Grooming & Coercion',
      'text': "I will give you free Robux and gift cards, just meet me alone in your room and video call without clothes.",
      'description': 'Tests material luring ("free Robux") + private solicitation ("alone without clothes").',
    },
    {
      'title': '🛡️ Benign Safe Conversation',
      'app': 'Family Chat',
      'category': 'Benign Communication',
      'text': "Hey mom, I finished my science homework and project. Can I go to Rahul's house for group study at 5?",
      'description': 'Normal everyday conversation with zero harm markers (Benchmark baseline).',
    },
  ];

  @override
  void initState() {
    super.initState();
    _applyPreset(0);
  }

  void _applyPreset(int index) {
    setState(() {
      _selectedPresetIndex = index;
      _textController.text = _presets[index]['text']!;
      _analysisResult = null;
    });
  }

  Future<void> _runAnalysis() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _scanStep = 'Tokenizing text & NLP normalization...';
    });

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() => _scanStep = '1/4 Grooming Agent: Probing secrecy & intimacy cues...');

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _scanStep = '2/4 Bullying Agent: Scanning insults & hostility...');

    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    setState(() => _scanStep = '3/4 Indic Agent: Evaluating Hinglish blackmail & slurs...');

    await Future.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() => _scanStep = '4/4 Supervisor Agent: Synthesizing consensus score...');

    final result = await ApiService.simulateSentence(text);

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
      _scanStep = '';
    });
  }

  void _injectIntoParentDashboard() {
    if (_analysisResult == null) return;
    final double score = (_analysisResult!['overall_risk_score'] as num?)?.toDouble() ?? 0.0;
    final preset = _presets[_selectedPresetIndex];

    final newIncident = {
      'id': 'inc-live-${DateTime.now().millisecondsSinceEpoch}',
      'child_id': 'child-aarav',
      'child_name': 'Aarav (Age 13)',
      'category': _analysisResult!['category'],
      'risk_score': score,
      'severity': _analysisResult!['severity'],
      'detected_reason': _analysisResult!['detected_reason'],
      'flagged_snippet': _textController.text.trim(),
      'app_source': preset['app'] ?? 'Live Test',
      'status': 'new',
      'created_at': DateTime.now().toIso8601String(),
      'agent_breakdown': _analysisResult!['agent_breakdown'],
    };

    ApiService.addLiveIncident(newIncident);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: RakshanTheme.safeGreen, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Incident Injected into Live Parent Portal!',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    'Child Risk Score updated to ${score.toStringAsFixed(1)} / 100.',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      appBar: AppBar(
        title: const Text('Live AI Detection Studio'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: RakshanTheme.safeGreenLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: RakshanTheme.safeGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: RakshanTheme.safeGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'MULTI-AGENT READY',
                  style: TextStyle(
                    color: RakshanTheme.safeGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Intro Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: RakshanTheme.primaryLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: RakshanTheme.primaryBlue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: RakshanTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: RakshanTheme.primaryBlue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Interactive Threat Detection Demo',
                          style: TextStyle(
                            color: RakshanTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Select any preset scenario below or type any custom phrase to test live Multi-Agent inference.',
                          style: TextStyle(
                            color: RakshanTheme.textMuted,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Presets Horizontal Reel
            const Text(
              'REAL-WORLD ATTACK PRESETS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: RakshanTheme.textMuted,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _presets.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final preset = _presets[index];
                  final isSelected = index == _selectedPresetIndex;

                  return GestureDetector(
                    onTap: () => _applyPreset(index),
                    child: Container(
                      width: 190,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : RakshanTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? RakshanTheme.primaryBlue : RakshanTheme.cardBorder,
                          width: isSelected ? 1.8 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: RakshanTheme.primaryBlue.withOpacity(0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            preset['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected ? RakshanTheme.primaryBlue : RakshanTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            preset['app']!,
                            style: const TextStyle(
                              color: RakshanTheme.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Message Input Box Card
            Container(
              padding: const EdgeInsets.all(16),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TEST MESSAGE PAYLOAD',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: RakshanTheme.textMuted,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: RakshanTheme.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _presets[_selectedPresetIndex]['app']!,
                          style: const TextStyle(
                            color: RakshanTheme.primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _textController,
                    maxLines: 3,
                    style: const TextStyle(
                      color: RakshanTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: RakshanTheme.surfaceMuted,
                      hintText: 'Type custom message in English or Hinglish...',
                      hintStyle: const TextStyle(color: RakshanTheme.textLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _presets[_selectedPresetIndex]['description']!,
                    style: const TextStyle(color: RakshanTheme.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 14),

                  // Run Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _isAnalyzing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                            )
                          : const Icon(Icons.bolt_rounded, size: 20),
                      label: Text(
                        _isAnalyzing ? _scanStep : 'Run Multi-Agent Live Detection',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RakshanTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _isAnalyzing ? null : _runAnalysis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Live Analysis Results Section
            if (_analysisResult != null) ...[
              _buildResultsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    final double score = (_analysisResult!['overall_risk_score'] as num?)?.toDouble() ?? 0.0;
    final String severity = _analysisResult!['severity'] ?? 'LOW';
    final String category = _analysisResult!['category'] ?? 'Benign';
    final String reason = _analysisResult!['detected_reason'] ?? '';
    final String action = _analysisResult!['recommended_action'] ?? '';
    final Map<String, dynamic> agents = _analysisResult!['agent_breakdown'] ?? {};
    final Color riskColor = RakshanTheme.getRiskColor(score);
    final Color riskBgColor = RakshanTheme.getRiskBgColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'LIVE DETECTION TELEMETRY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: RakshanTheme.textMuted,
                letterSpacing: 1.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: riskBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: riskColor.withOpacity(0.35)),
              ),
              child: Text(
                '$severity • $score / 100',
                style: TextStyle(
                  color: riskColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Primary Gauge Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: riskColor.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: riskColor.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                category.toUpperCase(),
                style: TextStyle(
                  color: riskColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              RiskGaugeWidget(
                score: score,
                status: severity,
                size: 210,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RakshanTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      score >= 70 ? Icons.warning_amber_rounded : Icons.verified_user_outlined,
                      color: riskColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        reason,
                        style: const TextStyle(
                          color: RakshanTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Specialized Micro-Agent Breakdown
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
              const Text(
                'EXPLAINABLE AI (XAI) MULTI-AGENT INFERENCE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: RakshanTheme.textMuted,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              _buildAgentRow(
                'Online Grooming & Secrecy Agent',
                (agents['grooming']?['score'] as num?)?.toDouble() ?? 0.0,
                (agents['grooming']?['confidence'] as num?)?.toDouble() ?? 0.9,
                Icons.person_pin_rounded,
              ),
              const Divider(color: RakshanTheme.cardBorder, height: 24),
              _buildAgentRow(
                'Cyberbullying & Toxicity Agent',
                (agents['bullying']?['score'] as num?)?.toDouble() ?? 0.0,
                (agents['bullying']?['confidence'] as num?)?.toDouble() ?? 0.9,
                Icons.groups_rounded,
              ),
              const Divider(color: RakshanTheme.cardBorder, height: 24),
              _buildAgentRow(
                'Indic & Hinglish Vernacular Agent',
                (agents['indic']?['score'] as num?)?.toDouble() ?? 0.0,
                (agents['indic']?['confidence'] as num?)?.toDouble() ?? 0.9,
                Icons.translate_rounded,
              ),
              const Divider(color: RakshanTheme.cardBorder, height: 24),
              _buildAgentRow(
                'Emotional Distress & Vulnerability Agent',
                (agents['emotion']?['score'] as num?)?.toDouble() ?? 0.0,
                (agents['emotion']?['confidence'] as num?)?.toDouble() ?? 0.85,
                Icons.favorite_border_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Recommended Compliance Action
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RakshanTheme.primaryLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: RakshanTheme.primaryBlue.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.shield_outlined, color: RakshanTheme.primaryBlue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Statutory Protocol & Parent Guidance',
                    style: TextStyle(
                      color: RakshanTheme.primaryBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                action,
                style: const TextStyle(
                  color: RakshanTheme.textPrimary,
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'DPDP Act 2023 §9 Protocol • POCSO Act 2012 §19 Digital Audit Trail',
                style: TextStyle(
                  color: RakshanTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Live Demo Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_alert_rounded, size: 18),
                label: const Text('Inject into Live Parent Portal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RakshanTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _injectIntoParentDashboard,
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.copy_rounded, size: 18, color: RakshanTheme.primaryBlue),
              label: const Text('Copy XAI', style: TextStyle(color: RakshanTheme.primaryBlue)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: RakshanTheme.primaryBlue),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _analysisResult.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('XAI payload copied to clipboard!')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildAgentRow(String name, double score, double confidence, IconData icon) {
    final barColor = RakshanTheme.getRiskColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: RakshanTheme.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: RakshanTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${score.toStringAsFixed(0)} / 100',
              style: TextStyle(
                color: barColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: (score / 100.0).clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 7,
          ),
        ),
      ],
    );
  }
}
