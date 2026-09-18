import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../data/models/mesh_node.dart';

class MeshRadarWidget extends StatefulWidget {
  final List<MeshNode> nodes;
  final Function(MeshNode)? onNodeSelected;

  const MeshRadarWidget({
    super.key,
    required this.nodes,
    this.onNodeSelected,
  });

  @override
  State<MeshRadarWidget> createState() => _MeshRadarWidgetState();
}

class _MeshRadarWidgetState extends State<MeshRadarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.faintBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Radar concentric rings and rotating sweep
            AnimatedBuilder(
              animation: _sweepController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 280),
                  painter: _RadarGridPainter(
                    sweepAngle: _sweepController.value * 2 * math.pi,
                  ),
                );
              },
            ),

            // Connection lines to active nodes
            CustomPaint(
              size: const Size(double.infinity, 280),
              painter: _RadarLinesPainter(nodes: widget.nodes),
            ),

            // Center Node ("My Location")
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.my_location,
                color: AppColors.onPrimary,
                size: 22,
              ),
            ),

            // Orbiting Peer Nodes
            ...widget.nodes.take(4).map((node) {
              return _buildNodeItem(node);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeItem(MeshNode node) {
    // Convert polar (angle, distance) to cartesian coordinates within widget box
    // Box dimensions: approx 340w x 280h
    final radius = 95.0 * node.radarDistance;
    final angle = node.radarAngle;
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);

    IconData nodeIcon;
    Color nodeColor;
    if (node.type == NodeType.teacher) {
      nodeIcon = Icons.school;
      nodeColor = AppColors.secondary;
    } else if (node.type == NodeType.relay) {
      nodeIcon = Icons.router;
      nodeColor = AppColors.onSurfaceVariant;
    } else {
      nodeIcon = Icons.person;
      nodeColor = node.protocol == ConnectionProtocol.bluetoothLe
          ? AppColors.primary
          : AppColors.secondary;
    }

    return Transform.translate(
      offset: Offset(dx, dy),
      child: GestureDetector(
        onTap: () => widget.onNodeSelected?.call(node),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(
                  color: nodeColor.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
              child: Icon(nodeIcon, size: 18, color: nodeColor),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.faintBorder),
              ),
              child: Text(
                node.name,
                style: AppTypography.labelSm.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarGridPainter extends CustomPainter {
  final double sweepAngle;

  _RadarGridPainter({required this.sweepAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final gridPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric circles
    final radii = [35.0, 70.0, 105.0, 130.0];
    for (final r in radii) {
      canvas.drawCircle(center, r, gridPaint);
    }

    // Draw cross hairs
    canvas.drawLine(
      Offset(center.dx - 130, center.dy),
      Offset(center.dx + 130, center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 130),
      Offset(center.dx, center.dy + 130),
      gridPaint,
    );

    // Draw rotating sweep beam
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: FractionalOffset.center,
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          Colors.transparent,
          AppColors.primary.withOpacity(0.18),
        ],
        transform: GradientRotation(sweepAngle),
      ).createShader(Rect.fromCircle(center: center, radius: 130));

    canvas.drawCircle(center, 130, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarGridPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle;
  }
}

class _RadarLinesPainter extends CustomPainter {
  final List<MeshNode> nodes;

  _RadarLinesPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final node in nodes.take(4)) {
      final radius = 95.0 * node.radarDistance;
      final angle = node.radarAngle;
      final target = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final linePaint = Paint()
        ..color = (node.type == NodeType.teacher
                ? AppColors.secondary
                : AppColors.primary)
            .withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      canvas.drawLine(center, target, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarLinesPainter oldDelegate) => false;
}
