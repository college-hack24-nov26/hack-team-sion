import 'live_notification_monitor_screen.dart';
import 'suspicious_games_screen.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import '../widgets/risk_gauge_widget.dart';
import '../widgets/incident_card.dart';
import 'incident_detail_screen.dart';
import 'pairing_screen.dart';
import 'live_detection_demo_screen.dart';
import 'role_selection_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _navIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic> _overviewData = {};
  int _selectedChildIndex = 0;
  String _activeFilter = 'ALL';

  List<Map<String, dynamic>> get _devices => [
        {
          'name': 'Aarav (Age 13)',
          'model': 'Samsung Galaxy S23',
          'score': ApiService.currentChildRiskScore,
          'status': ApiService.currentChildStatus,
        },
        {
          'name': 'Ananya (Age 10)',
          'model': 'Google Pixel 7a',
          'score': 12.0,
          'status': 'SAFE',
        },
      ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getDashboardOverview();
    setState(() {
      _overviewData = data;
      _isLoading = false;
    });
  }

  void _openLiveStudio() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LiveDetectionDemoScreen()),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RakshanTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [RakshanTheme.primaryBlue, RakshanTheme.secondaryCyan],
                ),
              ),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rakshan Parent Portal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                Text(
                  ApiService.currentUser?['full_name'] ?? 'Rajesh Sharma',
                  style: const TextStyle(fontSize: 11, color: RakshanTheme.textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Live Notification Shield',
            icon: const Icon(Icons.notifications_active_rounded, color: RakshanTheme.criticalRed),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveNotificationMonitorScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Suspicious Games Detector',
            icon: const Icon(Icons.sports_esports_rounded, color: RakshanTheme.highOrange),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SuspiciousGamesScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Live AI Threat Studio',
            icon: const Icon(Icons.psychology_rounded, color: RakshanTheme.primaryBlue),
            onPressed: _openLiveStudio,
          ),
          IconButton(
            tooltip: 'Pair Device',
            icon: const Icon(Icons.qr_code_rounded, color: RakshanTheme.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PairingScreen(isParentView: true)),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: RakshanTheme.textPrimary),
            onSelected: (val) {
              if (val == 'switch') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'switch',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded, size: 18, color: RakshanTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text('Switch Role / Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: RakshanTheme.primaryBlue))
          : IndexedStack(
              index: _navIndex,
              children: [
                _buildOverviewTab(),
                _buildRemoteControlsTab(),
                _buildThreatsTab(),
                const LiveDetectionDemoScreen(),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (idx) => setState(() => _navIndex = idx),
        backgroundColor: Colors.white,
        elevation: 6,
        indicatorColor: RakshanTheme.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: RakshanTheme.primaryBlue),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.phonelink_setup_rounded),
            selectedIcon: Icon(Icons.phonelink_lock_rounded, color: RakshanTheme.primaryBlue),
            label: 'Controls',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_rounded),
            selectedIcon: Icon(Icons.warning_rounded, color: RakshanTheme.criticalRed),
            label: 'Threats',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology_rounded, color: RakshanTheme.accentRose),
            label: 'AI Lab',
          ),
        ],
      ),
    );
  }

  // --- TAB 0: OVERVIEW & TELEMETRY ---
  Widget _buildOverviewTab() {
    final activeChild = _devices[_selectedChildIndex];
    final childScore = (activeChild['score'] as num?)?.toDouble() ?? 0.0;
    final riskColor = RakshanTheme.getRiskColor(childScore);
    final allIncidents = (_overviewData['recent_incidents'] as List?) ?? [];

    return RefreshIndicator(
      color: RakshanTheme.primaryBlue,
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Device Selector Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_devices.length, (idx) {
                  final dev = _devices[idx];
                  final isSelected = idx == _selectedChildIndex;
                  final double devScore = (dev['score'] as num?)?.toDouble() ?? 0.0;
                  final devColor = RakshanTheme.getRiskColor(devScore);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedChildIndex = idx),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                  color: RakshanTheme.primaryBlue.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: devColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dev['name'],
                            style: TextStyle(
                              color: isSelected ? RakshanTheme.textPrimary : RakshanTheme.textMuted,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),

            // Live Telemetry Pill Bar (Battery %, Active App, Online Status)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: RakshanTheme.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: RakshanTheme.safeGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'ONLINE NOW',
                        style: TextStyle(
                          color: RakshanTheme.safeGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.smartphone_rounded, size: 14, color: RakshanTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        'Active: ${ApiService.childActiveApp}',
                        style: const TextStyle(fontSize: 11, color: RakshanTheme.textPrimary, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.battery_charging_full_rounded, size: 16, color: RakshanTheme.primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        '${ApiService.childBatteryPercentage}%',
                        style: const TextStyle(fontSize: 12, color: RakshanTheme.primaryBlue, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Primary Risk Gauge Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: riskColor.withOpacity(0.35), width: 1.5),
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
                  const Text(
                    'CHILD CYBER RISK INDEX',
                    style: TextStyle(
                      color: RakshanTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activeChild['name'],
                    style: const TextStyle(
                      color: RakshanTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RiskGaugeWidget(
                    score: childScore,
                    status: activeChild['status'],
                    size: 210,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Two Core Real-Time Concept Features
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
                          Text('Live Notification Monitor', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: RakshanTheme.textPrimary)),
                          SizedBox(height: 2),
                          Text('AI Model Real-Time Risk Score', style: TextStyle(color: RakshanTheme.textMuted, fontSize: 10)),
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
                          Text('Suspicious Games Scanner', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: RakshanTheme.textPrimary)),
                          SizedBox(height: 2),
                          Text('Previous News History Intel', style: TextStyle(color: RakshanTheme.textMuted, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Remote Controller Quick Action Switches
            const Text(
              'REMOTE DEVICE CONTROLS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: RakshanTheme.textMuted,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _RemoteActionCard(
                  title: ApiService.isInternetPaused ? 'Resume Internet' : 'Pause Internet',
                  subtitle: ApiService.isInternetPaused ? 'Blocked' : 'Active',
                  icon: Icons.wifi_off_rounded,
                  isActive: ApiService.isInternetPaused,
                  activeColor: RakshanTheme.criticalRed,
                  onTap: () {
                    setState(() => ApiService.toggleInternetPause());
                    _showActionSnackbar(
                      ApiService.isInternetPaused
                          ? 'Child device Internet paused remotely!'
                          : 'Child device Internet resumed.',
                    );
                  },
                ),
                const SizedBox(width: 10),
                _RemoteActionCard(
                  title: ApiService.isDeviceLocked ? 'Unlock Screen' : 'Lock Screen',
                  subtitle: ApiService.isDeviceLocked ? 'Locked' : 'Unlocked',
                  icon: Icons.lock_outline_rounded,
                  isActive: ApiService.isDeviceLocked,
                  activeColor: RakshanTheme.highOrange,
                  onTap: () {
                    setState(() => ApiService.toggleDeviceLock());
                    _showActionSnackbar(
                      ApiService.isDeviceLocked
                          ? 'Child screen locked remotely.'
                          : 'Child screen unlocked.',
                    );
                  },
                ),
                const SizedBox(width: 10),
                _RemoteActionCard(
                  title: 'Bedtime Curfew',
                  subtitle: ApiService.isBedtimeModeActive ? 'Active' : 'Off',
                  icon: Icons.bedtime_outlined,
                  isActive: ApiService.isBedtimeModeActive,
                  activeColor: RakshanTheme.accentPurple,
                  onTap: () {
                    setState(() => ApiService.toggleBedtimeMode());
                    _showActionSnackbar(
                      ApiService.isBedtimeModeActive
                          ? 'Bedtime curfew mode active.'
                          : 'Bedtime mode disabled.',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Telemetry Stat Row
            Row(
              children: [
                _StatBox(
                  title: 'Active Threats',
                  value: '${_overviewData['active_threats_count'] ?? 1}',
                  icon: Icons.warning_amber_rounded,
                  color: RakshanTheme.criticalRed,
                  bgColor: RakshanTheme.criticalRedLight,
                ),
                const SizedBox(width: 12),
                _StatBox(
                  title: 'Safety Score',
                  value: '${(_overviewData['overall_family_safety_score'] as num?)?.toStringAsFixed(1) ?? '82.5'}%',
                  icon: Icons.shield_rounded,
                  color: RakshanTheme.safeGreen,
                  bgColor: RakshanTheme.safeGreenLight,
                ),
                const SizedBox(width: 12),
                _StatBox(
                  title: 'Devices Bound',
                  value: '${_overviewData['total_linked_devices'] ?? 2}',
                  icon: Icons.devices_rounded,
                  color: RakshanTheme.primaryBlue,
                  bgColor: RakshanTheme.primaryLight,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recent Threats Feed Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Detected Cyber Threats',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: RakshanTheme.textPrimary),
                ),
                TextButton(
                  onPressed: () => setState(() => _navIndex = 2),
                  child: const Text('View All', style: TextStyle(color: RakshanTheme.primaryBlue, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Top Incidents List
            if (allIncidents.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: RakshanTheme.cardBorder),
                ),
                child: const Text('No active threats recorded.', style: TextStyle(color: RakshanTheme.textMuted)),
              )
            else
              ...allIncidents.take(2).map((inc) {
                return IncidentCard(
                  incident: inc,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => IncidentDetailScreen(incident: inc)),
                    );
                    _loadData();
                  },
                );
              }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: REMOTE DEVICE CONTROLLER & APP BLOCKER ---
  Widget _buildRemoteControlsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device Hardware Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RakshanTheme.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.phone_android_rounded, color: RakshanTheme.primaryBlue, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aarav\'s Samsung Galaxy S23',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: RakshanTheme.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Android 14 • On-Device Shield v1.0.0 Active',
                        style: TextStyle(color: RakshanTheme.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: RakshanTheme.safeGreen, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Linked via Ngrok Production Gateway', style: TextStyle(color: RakshanTheme.safeGreen, fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Daily Screen Time Allocation
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: RakshanTheme.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daily Screen Time Limit', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: RakshanTheme.textPrimary)),
                    Text('${ApiService.dailyScreenTimeLimitHours.toStringAsFixed(1)} Hours/Day', style: const TextStyle(fontWeight: FontWeight.w800, color: RakshanTheme.primaryBlue, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: ApiService.dailyScreenTimeLimitHours,
                  min: 0.5,
                  max: 6.0,
                  divisions: 11,
                  activeColor: RakshanTheme.primaryBlue,
                  onChanged: (val) {
                    setState(() => ApiService.dailyScreenTimeLimitHours = val);
                  },
                ),
                Text(
                  '${ApiService.currentScreenTimeUsedHours.toStringAsFixed(1)}h consumed today • ${(ApiService.dailyScreenTimeLimitHours - ApiService.currentScreenTimeUsedHours).toStringAsFixed(1)}h remaining',
                  style: const TextStyle(color: RakshanTheme.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // App Blocker Matrix
          const Text(
            'REMOTE APPLICATION BLOCKER',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: RakshanTheme.textMuted, letterSpacing: 1.1),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: RakshanTheme.cardBorder),
            ),
            child: Column(
              children: ApiService.appBlockStatuses.entries.map((entry) {
                final isBlocked = entry.value;
                return SwitchListTile(
                  title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: RakshanTheme.textPrimary)),
                  subtitle: Text(
                    isBlocked ? 'Blocked remotely on child phone' : 'Allowed with live cyber monitoring',
                    style: TextStyle(color: isBlocked ? RakshanTheme.criticalRed : RakshanTheme.textMuted, fontSize: 12),
                  ),
                  value: !isBlocked, // true = allowed, false = blocked
                  activeThumbColor: RakshanTheme.safeGreen,
                  onChanged: (allowed) {
                    setState(() => ApiService.toggleAppBlock(entry.key));
                    _showActionSnackbar(allowed ? '${entry.key} allowed on child phone.' : '${entry.key} blocked on child phone!');
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Geofence Safe Zones
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: RakshanTheme.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: RakshanTheme.primaryBlue.withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.location_on_rounded, color: RakshanTheme.primaryBlue, size: 26),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Geofencing Safe Zones Active', style: TextStyle(fontWeight: FontWeight.w800, color: RakshanTheme.primaryBlue, fontSize: 14)),
                      SizedBox(height: 2),
                      Text('Home Safe Zone (500m) & School Safe Zone active. Push notification if child departs without guardian.', style: TextStyle(color: RakshanTheme.textMuted, fontSize: 11, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- TAB 2: THREAT INTELLIGENCE & INCIDENTS ---
  Widget _buildThreatsTab() {
    final allIncidents = (_overviewData['recent_incidents'] as List?) ?? [];
    final filtered = allIncidents.where((inc) {
      if (_activeFilter == 'CRITICAL') {
        return (inc['severity'] as String?)?.toUpperCase() == 'CRITICAL';
      } else if (_activeFilter == 'HIGH') {
        final double s = (inc['risk_score'] as num?)?.toDouble() ?? 0.0;
        return s >= 70.0;
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Threat Intelligence Feed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: RakshanTheme.textPrimary)),
              Text('${filtered.length} Recorded', style: const TextStyle(fontSize: 12, color: RakshanTheme.textMuted, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),

          // Filters
          Row(
            children: [
              _FilterChip(label: 'All (${allIncidents.length})', isSelected: _activeFilter == 'ALL', onTap: () => setState(() => _activeFilter = 'ALL')),
              const SizedBox(width: 8),
              _FilterChip(label: 'Critical Only', isSelected: _activeFilter == 'CRITICAL', onTap: () => setState(() => _activeFilter = 'CRITICAL')),
              const SizedBox(width: 8),
              _FilterChip(label: 'High Risk', isSelected: _activeFilter == 'HIGH', onTap: () => setState(() => _activeFilter = 'HIGH')),
            ],
          ),
          const SizedBox(height: 16),

          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: RakshanTheme.cardBorder)),
              child: const Text('No matching incidents found.', style: TextStyle(color: RakshanTheme.textMuted)),
            )
          else
            ...filtered.map((inc) {
              return IncidentCard(
                incident: inc,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => IncidentDetailScreen(incident: inc)),
                  );
                  _loadData();
                },
              );
            }),
        ],
      ),
    );
  }

  void _showActionSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: const Color(0xFF0F172A),
      ),
    );
  }
}

class _RemoteActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _RemoteActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: isActive ? activeColor.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive ? activeColor.withOpacity(0.4) : RakshanTheme.cardBorder,
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: isActive ? activeColor : RakshanTheme.textMuted, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isActive ? activeColor : RakshanTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: isActive ? activeColor : RakshanTheme.textMuted, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? RakshanTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? RakshanTheme.primaryBlue : RakshanTheme.cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : RakshanTheme.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: RakshanTheme.cardBorder),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(color: RakshanTheme.textPrimary, fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(color: RakshanTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
