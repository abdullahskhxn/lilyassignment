import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlaceholderMap extends StatelessWidget {
  final double height;
  final List<Offset>? hostPositions;

  const PlaceholderMap({
    super.key,
    this.height = 300,
    this.hostPositions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withAlpha(80)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CustomPaint(
          painter: _MapPainter(
            hostPositions: hostPositions ??
                const [
                  Offset(0.3, 0.4),
                  Offset(0.6, 0.25),
                  Offset(0.2, 0.65),
                  Offset(0.75, 0.55),
                  Offset(0.5, 0.7),
                ],
          ),
          child: Stack(
            children: [
              // Center user pin
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.my_location, color: AppColors.accent, size: 32),
                    SizedBox(height: 4),
                    Text(
                      'You',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Map label
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined, color: AppColors.primary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Local Network Map',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final List<Offset> hostPositions;

  const _MapPainter({required this.hostPositions});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.primary.withAlpha(20)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    const gridSpacing = 30.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw range circles
    final circlePaint = Paint()
      ..color = AppColors.primary.withAlpha(15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    for (final r in [50.0, 100.0, 150.0]) {
      canvas.drawCircle(center, r, circlePaint);
    }

    // Draw host pins
    for (final pos in hostPositions) {
      final x = pos.dx * size.width;
      final y = pos.dy * size.height;

      // Pulse ring
      final pulsePaint = Paint()
        ..color = AppColors.primary.withAlpha(30)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 14, pulsePaint);

      // Host dot
      final dotPaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 7, dotPaint);

      // Connection line to center
      final linePaint = Paint()
        ..color = AppColors.primary.withAlpha(40)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(center, Offset(x, y), linePaint);
    }

    // Draw a subtle road-like pattern
    final roadPaint = Paint()
      ..color = AppColors.primary.withAlpha(12)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.4,
        size.width * 0.6,
        size.height * 0.35,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.3,
        size.width,
        size.height * 0.45,
      );
    canvas.drawPath(path, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.4,
        size.width * 0.4,
        size.height,
      );
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
