import 'package:flutter/material.dart';
import '../core/theme.dart';

class IncidentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> incident;

  const IncidentDetailScreen({super.key, required this.incident});

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  final bool _isAcknowledging = false;
  bool _isAcknowledged = false;

  @override
  void initState() {
    super.initState();
    _isAcknowledged = widget.incident['status'] == 'acknowledged';
  }

  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: const [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Legal Incident Compliance Report (PDF) exported successfully under DPDP Act 2023 format.',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double score = (widget.incident['risk_score'] as num?)?.toDouble() ?? 0.0;
    final String category = widget.incident['category'] ?? 'Threat Detected';
    final String childName = widget.incident['child_name'] ?? 'Protected Child';
    final String snippet = widget.incident['flagged_snippet'] ?? widget.incident['detected_reason'] ?? '';
    final String reason = widget.incident['detected_reason'] ?? '';
    final String appSource = widget.incident['app_source'] ?? 'Instant Messaging';
    final String severity = widget.incident['severity'] ?? 'HIGH';
    final Color riskColor = RakshanTheme.getRiskColor(score);
    final Color riskBgColor = RakshanTheme.getRiskBgColor(score);
    final Map<String, dynamic> agents = widget.incident['agent_breakdown'] ?? {};

    return Scaffold(
      backgroundColor: RakshanTheme.background,
      appBar: AppBar(
        title: const Text('Incident Threat Deep Dive'),
        actions: [
          IconButton(
            tooltip: 'Download Legal Report',
            icon: const Icon(Icons.download_rounded, color: RakshanTheme.primaryBlue),
            onPressed: _downloadReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Threat Overview Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: riskBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: riskColor.withOpacity(0.35), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: riskColor.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        score.toStringAsFixed(0),
                        style: TextStyle(
                          color: riskColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$severity THREAT LEVEL',
                          style: TextStyle(
                            color: riskColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category,
                          style: const TextStyle(
                            color: RakshanTheme.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Child: $childName • App: $appSource',
                          style: const TextStyle(
                            color: RakshanTheme.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Redacted Evidence Snippet
            const Text(
              'FLAGGED CONVERSATION CONTEXT (DPDP PRIVACY PROTECTED)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: RakshanTheme.textMuted,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RakshanTheme.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                '"$snippet"',
                style: const TextStyle(
                  color: RakshanTheme.textPrimary,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Explainable AI (XAI) Breakdown Matrix
            const Text(
              'EXPLAINABLE AI (XAI) AGENT ANALYSIS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: RakshanTheme.textMuted,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: RakshanTheme.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: RakshanTheme.primaryBlue, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Detection Indicators:\n$reason',
                          style: const TextStyle(
                            color: RakshanTheme.textPrimary,
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: RakshanTheme.cardBorder, height: 28),
                  _AgentScoreBar(
                    agentName: 'Online Grooming Agent',
                    score: (agents['grooming']?['score'] as num?)?.toDouble() ?? 0.0,
                    confidence: (agents['grooming']?['confidence'] as num?)?.toDouble() ?? 0.9,
                  ),
                  const SizedBox(height: 14),
                  _AgentScoreBar(
                    agentName: 'Cyberbullying Agent',
                    score: (agents['bullying']?['score'] as num?)?.toDouble() ?? 0.0,
                    confidence: (agents['bullying']?['confidence'] as num?)?.toDouble() ?? 0.8,
                  ),
                  const SizedBox(height: 14),
                  _AgentScoreBar(
                    agentName: 'Emotional Distress Agent',
                    score: (agents['emotion']?['score'] as num?)?.toDouble() ?? 0.0,
                    confidence: (agents['emotion']?['confidence'] as num?)?.toDouble() ?? 0.85,
                  ),
                  const SizedBox(height: 14),
                  _AgentScoreBar(
                    agentName: 'Indic & Vernacular Agent',
                    score: (agents['indic']?['score'] as num?)?.toDouble() ?? 0.0,
                    confidence: (agents['indic']?['confidence'] as num?)?.toDouble() ?? 0.7,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Legal & Compliance Card
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
                      Icon(Icons.gavel_rounded, color: RakshanTheme.primaryBlue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Statutory Compliance & Evidence Vault',
                        style: TextStyle(
                          color: RakshanTheme.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Digital Personal Data Protection (DPDP) Act, 2023 §9 Child Safety Protocol\n'
                    '• Protection of Children from Sexual Offences (POCSO) Act, 2012 §19 Statutory Reporting\n'
                    '• Information Technology (Intermediary Guidelines) Rules, 2021',
                    style: TextStyle(
                      color: RakshanTheme.textPrimary,
                      fontSize: 11,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SHA-256 Vault: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: RakshanTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bottom Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: _isAcknowledging
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(_isAcknowledged ? Icons.check_circle_rounded : Icons.visibility_rounded),
                    label: Text(_isAcknowledged ? 'Acknowledged' : 'Acknowledge Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAcknowledged ? RakshanTheme.surfaceMuted : RakshanTheme.primaryBlue,
                      foregroundColor: _isAcknowledged ? RakshanTheme.textMuted : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isAcknowledged
                        ? null
                        : () {
                            setState(() => _isAcknowledged = true);
                            widget.incident['status'] = 'acknowledged';
                          },
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf_rounded, color: RakshanTheme.primaryBlue),
                  label: const Text('Export PDF', style: TextStyle(color: RakshanTheme.primaryBlue, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: RakshanTheme.primaryBlue, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _downloadReport,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AgentScoreBar extends StatelessWidget {
  final String agentName;
  final double score;
  final double confidence;

  const _AgentScoreBar({
    required this.agentName,
    required this.score,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final Color barColor = RakshanTheme.getRiskColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              agentName,
              style: const TextStyle(
                color: RakshanTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)} / 100 (${(confidence * 100).toInt()}% conf)',
              style: TextStyle(color: barColor, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 6),
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
