import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/mesh_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../state/broadcast_state.dart';
import '../../data/models/urgent_alert.dart';

class UrgentAlertScreen extends StatelessWidget {
  const UrgentAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcastState = context.watch<BroadcastState>();
    final alert = broadcastState.urgentAlert;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emergency Warning Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x5593000A),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.emergencyVibrant,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.emergency,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.emergencyVibrant,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CRITICAL OVERRIDE',
                              style: AppTypography.labelSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'MESH BROADCAST ${alert.broadcastNumber}',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onErrorContainer.withOpacity(0.9),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alert.title,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onErrorContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Emergency services have issued an immediate safety warning across interconnected offline mesh nodes.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onErrorContainer.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Message Details & Status Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.faintBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const PulseIndicator(
                            color: AppColors.emergencyVibrant, size: 6),
                        const SizedBox(width: 6),
                        Text(
                          'LIVE BROADCAST ACTIVE',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      alert.timeAgo,
                      style: AppTypography.labelSm,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    alert.description,
                    style: AppTypography.bodyLg.copyWith(
                      height: 1.45,
                      color: AppColors.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BROADCAST SOURCE',
                              style: AppTypography.labelSm.copyWith(fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.verified_user,
                                    size: 15, color: AppColors.secondary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    alert.source,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySm.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MESH PROPAGATION',
                              style: AppTypography.labelSm.copyWith(fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.hub,
                                    size: 15, color: AppColors.secondary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${alert.nodesSynced} Nodes Synced',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySm.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Affected Sectors Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Affected Sectors',
                style: AppTypography.headlineSm.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${alert.sectors.length} ZONES IMPACTED',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...alert.sectors.map((sec) {
            final isCritical = sec.severity == SectorSeverity.critical;
            final isShelter = sec.severity == SectorSeverity.shelter;

            Color badgeColor;
            Color badgeBg;
            IconData iconData;

            if (isCritical) {
              badgeColor = AppColors.error;
              badgeBg = AppColors.errorContainer.withOpacity(0.5);
              iconData = Icons.warning_amber_rounded;
            } else if (isShelter) {
              badgeColor = AppColors.secondary;
              badgeBg = AppColors.secondaryContainer.withOpacity(0.2);
              iconData = Icons.info_outline;
            } else {
              badgeColor = AppColors.secondary;
              badgeBg = AppColors.secondaryContainer.withOpacity(0.15);
              iconData = Icons.info_outline;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.faintBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(iconData, color: badgeColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sec.name,
                            style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            sec.instruction,
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        sec.severityLabel,
                        style: AppTypography.labelSm.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // Acknowledge Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: alert.isAcknowledged
                    ? AppColors.surfaceContainerHigh
                    : AppColors.error,
                foregroundColor: alert.isAcknowledged
                    ? AppColors.secondary
                    : AppColors.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: alert.isAcknowledged
                  ? null
                  : () {
                      broadcastState.acknowledgeAlert();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Pingback Logged Successfully: Mesh nodes updated with your safe status confirmation.'),
                        ),
                      );
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    alert.isAcknowledged ? Icons.verified : Icons.task_alt,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    alert.isAcknowledged
                        ? 'Receipt Confirmed & Logged'
                        : 'Acknowledge & Confirm Receipt',
                    style: AppTypography.headlineSm.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: alert.isAcknowledged
                          ? AppColors.secondary
                          : AppColors.onError,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Confirming logs your device ID and safety status back to local mesh nodes.',
              style: AppTypography.bodySm.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
