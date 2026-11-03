import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';

class SuspiciousGamesScreen extends StatefulWidget {
  const SuspiciousGamesScreen({super.key});

  @override
  State<SuspiciousGamesScreen> createState() => _SuspiciousGamesScreenState();
}

class _SuspiciousGamesScreenState extends State<SuspiciousGamesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isScanning = false;
  Map<String, dynamic>? _scanReport;
  List<dynamic> _threatCatalog = [];
  bool _isLoadingCatalog = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadThreatCatalog();
    _performInitialScan();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadThreatCatalog() async {
    final catalog = await ApiService.getThreatCatalog();
    if (mounted) {
      setState(() {
        _threatCatalog = catalog;
        _isLoadingCatalog = false;
      });
    }
  }

  Future<void> _performInitialScan({bool includeSimulatedThreats = true}) async {
    setState(() => _isScanning = true);

    // 1. Fetch real installed apps on the phone via Android PackageManager
    final realApps = await ApiService.getInstalledAppsFromDevice();

    // 2. Prepare payload (add simulated notorious games if enabled for live demonstration)
    final appsToScan = List<Map<String, dynamic>>.from(realApps);

    if (includeSimulatedThreats) {
      appsToScan.addAll([
        {'app_name': 'Garena Free Fire MAX', 'package_name': 'com.dts.freefiremax'},
        {'app_name': 'Roblox Mobile', 'package_name': 'com.roblox.client'},
        {'app_name': 'Teen Patti Real Cash Game', 'package_name': 'com.teenpatti.cards'},
      ]);
    }

    final report = await ApiService.scanInstalledGames(appsToScan);

    if (mounted) {
      setState(() {
        _scanReport = report;
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      appBar: AppBar(
        title: const Text('Suspicious Games & App Detector'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: RakshanTheme.primaryBlue,
          unselectedLabelColor: RakshanTheme.textMuted,
          indicatorColor: RakshanTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: const [
            Tab(text: 'Device App Scanner', icon: Icon(Icons.security_rounded, size: 20)),
            Tab(text: 'News Threat Intel', icon: Icon(Icons.newspaper_rounded, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScannerTab(),
          _buildCatalogTab(),
        ],
      ),
    );
  }

  Widget _buildScannerTab() {
    if (_isScanning) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: RakshanTheme.primaryBlue),
            SizedBox(height: 16),
            Text(
              'Scanning Device Applications Against News Threat Database...',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            SizedBox(height: 6),
            Text(
              'Checking against past extortion, dark patterns & suicide challenges',
              style: TextStyle(fontSize: 11, color: RakshanTheme.textMuted),
            ),
          ],
        ),
      );
    }

    final double gameRisk = (_scanReport?['overall_game_risk_score'] as num?)?.toDouble() ?? 0.0;
    final int flaggedCount = (_scanReport?['flagged_count'] as num?)?.toInt() ?? 0;
    final int totalScanned = (_scanReport?['total_scanned'] as num?)?.toInt() ?? 0;
    final List flaggedGames = (_scanReport?['flagged_games'] as List?) ?? [];
    final Color riskColor = RakshanTheme.getRiskColor(gameRisk);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device Game Risk Summary Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: riskColor.withOpacity(0.4), width: 1.8),
              boxShadow: [
                BoxShadow(
                  color: riskColor.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEVICE GAME THREAT INDEX',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: RakshanTheme.textMuted,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${gameRisk.toStringAsFixed(0)} / 100',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: riskColor,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _scanReport?['status'] ?? 'CLEAN',
                        style: TextStyle(
                          color: riskColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        label: 'Total Scanned',
                        value: '$totalScanned Apps',
                        icon: Icons.apps_rounded,
                        color: RakshanTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricTile(
                        label: 'Threats Detected',
                        value: '$flaggedCount Flagged',
                        icon: Icons.warning_amber_rounded,
                        color: flaggedCount > 0 ? RakshanTheme.criticalRed : RakshanTheme.safeGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Scan Phone Only', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _performInitialScan(includeSimulatedThreats: false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.pest_control_rounded, size: 16),
                        label: const Text('Test Inject Cues', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RakshanTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _performInitialScan(includeSimulatedThreats: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Flagged Games Feed Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FLAGGED SUSPICIOUS GAMES & HISTORY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: RakshanTheme.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: RakshanTheme.criticalRedLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$flaggedCount High-Risk Items',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: RakshanTheme.criticalRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List of Flagged Games
          if (flaggedGames.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: RakshanTheme.cardBorder),
              ),
              child: Center(
                child: Column(
                  children: const [
                    Icon(Icons.check_circle_outline_rounded, size: 48, color: RakshanTheme.safeGreen),
                    SizedBox(height: 10),
                    Text(
                      'No Dangerous Games Detected!',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'All installed packages on this phone are within safe parameters.',
                      style: TextStyle(fontSize: 11, color: RakshanTheme.textMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            ...flaggedGames.map((item) {
              final threat = item['threat_info'] as Map<String, dynamic>? ?? {};
              final double score = (threat['risk_score'] as num?)?.toDouble() ?? 80.0;
              final Color sColor = RakshanTheme.getRiskColor(score);

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: sColor.withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['app_name'] ?? 'Flagged App',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: RakshanTheme.textPrimary,
                                ),
                              ),
                              Text(
                                item['package_name'] ?? '',
                                style: const TextStyle(fontSize: 10.5, color: RakshanTheme.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: sColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'RISK ${score.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: sColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Threat Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: RakshanTheme.criticalRedLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '⚠️ Threat: ${threat['threat_type'] ?? 'Cyber Harm Threat'}',
                        style: const TextStyle(
                          color: RakshanTheme.criticalRed,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Real News History Callout
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.newspaper_rounded, size: 14, color: Color(0xFFB45309)),
                              SizedBox(width: 6),
                              Text(
                                'VERIFIED PREVIOUS NEWS HISTORY & CASES:',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFB45309),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            threat['news_headline'] ?? '',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF78350F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            threat['news_history'] ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.35,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Recommended Action
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, size: 14, color: RakshanTheme.primaryBlue),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            threat['recommended_action'] ?? 'Review app usage limits with child.',
                            style: const TextStyle(
                              fontSize: 11,
                              color: RakshanTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildCatalogTab() {
    if (_isLoadingCatalog) {
      return const Center(child: CircularProgressIndicator(color: RakshanTheme.primaryBlue));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _threatCatalog.length,
      itemBuilder: (ctx, i) {
        final threat = _threatCatalog[i] as Map<String, dynamic>;
        final double score = (threat['risk_score'] as num?)?.toDouble() ?? 80.0;
        final Color scoreColor = RakshanTheme.getRiskColor(score);

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      threat['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: RakshanTheme.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${score.toStringAsFixed(0)}/100',
                      style: TextStyle(
                        color: scoreColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Type: ${threat['threat_type'] ?? ''}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: RakshanTheme.criticalRed,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: RakshanTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  threat['news_history'] ?? '',
                  style: const TextStyle(
                    fontSize: 11,
                    color: RakshanTheme.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: RakshanTheme.textMuted, fontWeight: FontWeight.w600)),
                Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

