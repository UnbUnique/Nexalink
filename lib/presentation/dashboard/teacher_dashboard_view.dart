import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/mesh_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../state/app_state.dart';
import '../../state/broadcast_state.dart';

class TeacherDashboardView extends StatelessWidget {
  final VoidCallback onBroadcastTap;

  const TeacherDashboardView({
    super.key,
    required this.onBroadcastTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final broadcastState = context.watch<BroadcastState>();
    final teacherAnnouncements = broadcastState.teacherAnnouncements;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting & Profile Status Banner
          MeshCard(
            padding: const EdgeInsets.all(18),
            backgroundColor: AppColors.surfaceContainerLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                              color: AppColors.secondary.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              'Mesh Node Active',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '• 4.2 GHz Subnet',
                            style: AppTypography.labelSm,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Dr. Alan Grant',
                        style: AppTypography.headlineLgMobile.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Paleo-Lab Sector B • Local Mesh Synchronized',
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.biotech,
                    color: AppColors.onPrimaryContainer,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Quick Stats Cards Grid
          Row(
            children: [
              // Connected Peers Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                          Text(
                            'CONNECTED PEERS',
                            style: AppTypography.labelSm.copyWith(
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.hub,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '24',
                            style: AppTypography.headlineLg.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Row(
                            children: [
                              const Icon(Icons.arrow_upward,
                                  size: 12, color: AppColors.secondary),
                              Text(
                                '3 new',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const PulseIndicator(color: AppColors.secondary, size: 5),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Direct BT & Wi-Fi Direct',
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm.copyWith(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Active Broadcasts Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                          Text(
                            'ACTIVE BROADCASTS',
                            style: AppTypography.labelSm.copyWith(
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wifi_tethering,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '3',
                            style: AppTypography.headlineLg.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Live rooms',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'All packets relayed',
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySm.copyWith(fontSize: 11),
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
          const SizedBox(height: 22),

          // Quick Actions Section
          Text(
            'QUICK ACTIONS',
            style: AppTypography.labelSm.copyWith(
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Broadcast Announcement Button
          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onBroadcastTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.onPrimary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.campaign,
                        color: AppColors.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Broadcast Announcement',
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Push instantly to all connected student nodes',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onPrimary.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.onPrimary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Send Urgent Alert Button
          Material(
            color: AppColors.errorContainer,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                appState.setTab(NavigationTab.alerts);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.onErrorContainer.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emergency_outlined,
                        color: AppColors.onErrorContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Urgent Alert',
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.onErrorContainer,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Override classroom screens immediately',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onErrorContainer.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.onErrorContainer),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Select Active Class Button
          Material(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                appState.setTab(NavigationTab.classes);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Active Class',
                            style: AppTypography.headlineSm.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Current: ${broadcastState.activeClass.code} (${broadcastState.activeClass.name})',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Switch',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.swap_horiz,
                              size: 14, color: AppColors.secondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Mesh Broadcasts Feed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT MESH BROADCASTS',
                style: AppTypography.labelSm.copyWith(
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => appState.setTab(NavigationTab.messages),
                child: Text(
                  'View History',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...teacherAnnouncements.map((ann) {
            final isPaleo = ann.classCode.contains('PALEO');
            final badgeColor = isPaleo ? AppColors.secondary : AppColors.primary;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MeshCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: badgeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              ann.classCode,
                              style: AppTypography.labelSm.copyWith(
                                color: badgeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ann.timeAgo,
                          style: AppTypography.labelSm,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ann.title,
                      style: AppTypography.headlineSm.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ann.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.done_all,
                                size: 16, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              ann.deliveryChannel,
                              style: AppTypography.bodySm,
                            ),
                          ],
                        ),
                        Text(
                          'Synced (${ann.syncPercentage}%)',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
