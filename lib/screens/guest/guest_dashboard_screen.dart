import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sidebar.dart';
import '../../providers/app_provider.dart';

class GuestDashboardScreen extends StatefulWidget {
  const GuestDashboardScreen({super.key});

  @override
  State<GuestDashboardScreen> createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  bool _isConnected = true;
  bool _showPassword = false;
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showRatingSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rate Your Host',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    onPressed: () => setModalState(() => _rating = i + 1),
                    icon: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFB300),
                      size: 36,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _commentController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Leave a comment (optional)',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Submit Rating'),
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
    final provider = context.watch<AppProvider>();
    final host = provider.selectedHost ?? provider.dummyHosts[0];
    final remaining = provider.remainingData;
    final quota = provider.selectedQuota.toDouble();
    final usedFraction = quota > 0 ? (quota - remaining) / quota : 0.0;

    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 800;
      return Scaffold(
        backgroundColor: AppColors.background,
        drawer: isWide ? null : const Sidebar(role: 'guest', currentRoute: '/guest/dashboard'),
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: isWide
              ? null
              : Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
          title: const Text('Active Session'),
          actions: [
            TextButton.icon(
              onPressed: _showRatingSheet,
              icon: const Icon(Icons.star_outline, color: AppColors.primary, size: 18),
              label: const Text('Rate Host', style: TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
          ],
        ),
        body: Row(
          children: [
            if (isWide) const Sidebar(role: 'guest', currentRoute: '/guest/dashboard'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Connection status card
                    _buildStatusCard(host.name),
                    const SizedBox(height: 16),
                    // Credentials
                    _buildCredentialsCard(host.ssid),
                    const SizedBox(height: 16),
                    // Data usage
                    _buildDataUsageCard(remaining, quota, usedFraction),
                    const SizedBox(height: 16),
                    // Speed
                    _buildSpeedCard(),
                    const SizedBox(height: 24),
                    // Disconnect button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() => _isConnected = false);
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: AppColors.surface,
                              title: const Text('Disconnected', style: TextStyle(color: AppColors.textPrimary)),
                              content: const Text('You have been disconnected from the network.', style: TextStyle(color: AppColors.textSecondary)),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.go('/guest/nearby');
                                  },
                                  child: const Text('Find New Host'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.power_settings_new, size: 18),
                        label: const Text('Disconnect'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error.withAlpha(120)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatusCard(String hostName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(40),
            AppColors.primaryDark.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(120)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _isConnected ? const Color(0xFF4CAF50) : AppColors.error,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isConnected ? const Color(0xFF4CAF50) : AppColors.error).withAlpha(120),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isConnected ? 'CONNECTED' : 'DISCONNECTED',
                  style: TextStyle(
                    color: _isConnected ? const Color(0xFF4CAF50) : AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  hostName,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('12:34:56', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
              Text('Session time', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialsCard(String ssid) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Network Credentials', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          _buildCredRow('SSID', ssid, false),
          const SizedBox(height: 8),
          _buildCredRow('Password', _showPassword ? 'Str@ta2024!' : '••••••••••••', true),
        ],
      ),
    );
  }

  Widget _buildCredRow(String label, String value, bool hasToggle) {
    return Row(
      children: [
        Text('$label:', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ),
        if (hasToggle)
          IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
              size: 18,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
      ],
    );
  }

  Widget _buildDataUsageCard(double remaining, double quota, double usedFraction) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Data Usage',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${remaining.toStringAsFixed(1)} GB remaining',
                style: const TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  painter: _CircularProgressPainter(progress: usedFraction),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(usedFraction * 100).toInt()}%',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'used',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDataItem('Used', '${(quota - remaining).toStringAsFixed(1)} GB', AppColors.primary),
                    const SizedBox(height: 8),
                    _buildDataItem('Remaining', '${remaining.toStringAsFixed(1)} GB', AppColors.accent),
                    const SizedBox(height: 8),
                    _buildDataItem('Total', '${quota.toStringAsFixed(0)} GB', AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSpeedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSpeedIndicator(Icons.arrow_downward, '42.5', 'Mbps', 'Download'),
          Container(width: 1, height: 50, color: AppColors.divider),
          _buildSpeedIndicator(Icons.arrow_upward, '18.2', 'Mbps', 'Upload'),
          Container(width: 1, height: 50, color: AppColors.divider),
          _buildSpeedIndicator(Icons.network_ping, '12', 'ms', 'Ping'),
        ],
      ),
    );
  }

  Widget _buildSpeedIndicator(IconData icon, String value, String unit, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  const _CircularProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final bgPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    const startAngle = -3.14159 / 2;
    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) =>
      old.progress != progress;
}
