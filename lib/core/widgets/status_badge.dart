import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'pulse_indicator.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final bool showPulse;
  final Color pulseColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.surfaceContainerHigh,
    this.textColor = AppColors.secondary,
    this.icon,
    this.showPulse = false,
    this.pulseColor = AppColors.secondary,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: textColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPulse) ...[
            PulseIndicator(color: pulseColor, size: 6),
            const SizedBox(width: 6),
          ],
          if (icon != null && !showPulse) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: badge,
      );
    }

    return badge;
  }
}
