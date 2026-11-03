import 'package:flutter/material.dart';
import '../core/theme.dart';

class IncidentCard extends StatelessWidget {
  final Map<String, dynamic> incident;
  final VoidCallback onTap;

  const IncidentCard({
    super.key,
    required this.incident,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double score = (incident['risk_score'] as num?)?.toDouble() ?? 0.0;
    final String category = incident['category'] ?? 'Threat Detected';
    final String childName = incident['child_name'] ?? 'Protected Child';
    final String snippet = incident['flagged_snippet'] ?? incident['detected_reason'] ?? '';
    final String appSource = incident['app_source'] ?? 'Messaging';
    final String severity = incident['severity'] ?? 'HIGH';
    final Color riskColor = RakshanTheme.getRiskColor(score);
    final Color riskBgColor = RakshanTheme.getRiskBgColor(score);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RakshanTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: severity == 'CRITICAL' ? riskColor.withOpacity(0.35) : RakshanTheme.cardBorder,
            width: severity == 'CRITICAL' ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            if (severity == 'CRITICAL')
              BoxShadow(
                color: riskColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: App badge, Child name, and Score badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: RakshanTheme.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appSource,
                        style: const TextStyle(
                          color: RakshanTheme.primaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      childName,
                      style: const TextStyle(
                        color: RakshanTheme.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: riskColor.withOpacity(0.35)),
                  ),
                  child: Text(
                    '${score.toStringAsFixed(1)} Risk',
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

            // Threat Category Title
            Text(
              category,
              style: const TextStyle(
                color: RakshanTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),

            // Redacted snippet
            Text(
              '"$snippet"',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: RakshanTheme.textMuted,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // Footer: XAI trigger & status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: incident['status'] == 'new'
                        ? RakshanTheme.warningAmberLight
                        : RakshanTheme.safeGreenLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    incident['status'] == 'new' ? '⚠️ Action Required' : '✓ Acknowledged',
                    style: TextStyle(
                      color: incident['status'] == 'new'
                          ? RakshanTheme.warningAmber
                          : RakshanTheme.safeGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Row(
                  children: const [
                    Text(
                      'Explain AI Reason',
                      style: TextStyle(
                        color: RakshanTheme.primaryBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: RakshanTheme.primaryBlue,
                      size: 11,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
