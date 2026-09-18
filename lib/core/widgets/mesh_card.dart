import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MeshCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Color? leftBorderColor;
  final double leftBorderWidth;
  final bool hasGlow;
  final Color glowColor;

  const MeshCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.leftBorderColor,
    this.leftBorderWidth = 4.0,
    this.hasGlow = false,
    this.glowColor = AppColors.purpleGlow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceContainerLow,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: AppColors.faintBorder,
          width: 1,
        ),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: glowColor,
                  blurRadius: 24,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                )
              ]
            : null,
      ),
      child: child,
    );

    if (leftBorderColor != null) {
      content = ClipRRect(
        borderRadius: effectiveRadius,
        child: Stack(
          children: [
            content,
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: leftBorderWidth,
              child: Container(color: leftBorderColor),
            ),
          ],
        ),
      );
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: content,
        ),
      );
    }

    return content;
  }
}
