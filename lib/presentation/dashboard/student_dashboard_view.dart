import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/mesh_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../state/app_state.dart';
import '../../state/broadcast_state.dart';
import '../../state/message_state.dart';
import '../../data/models/chat_message.dart';

class StudentDashboardView extends StatelessWidget {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final broadcastState = context.watch<BroadcastState>();
    final messageState = context.watch<MessageState>();

    final user = appState.currentUser;
    final classes = broadcastState.classes;
    final announcements = broadcastState.studentAnnouncements;
    final threads = messageState.threads;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile & Mesh Status Card
          MeshCard(
            padding: const EdgeInsets.all(18),
            backgroundColor: AppColors.surfaceContainerLow,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Avatar with pulse dot
                        Stack(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(2.5),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    user.initials,
                                    style: AppTypography.headlineSm.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.surface, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: AppTypography.headlineMd.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.school, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  '${user.department} • ${user.titleOrYear}',
                                  style: AppTypography.bodySm,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // My Mesh ID QR Trigger
                    InkWell(
                      onTap: () => _showMeshIdDialog(context, user.meshId),
                      borderRadius: BorderRadius.circular(9999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: AppColors.faintBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.qr_code, size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              'My Mesh ID',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Signal & Battery Grid
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.wifi_tethering,
                                color: AppColors.secondary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MESH STATUS',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Strong Signal',
                                  style: AppTypography.bodyMd.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '12 Nodes Nearby',
                                  style: AppTypography.labelSm.copyWith(fontSize: 10),
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
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.bolt,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SYNC BATTERY',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Optimal (98%)',
                                  style: AppTypography.bodyMd.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Peer Relay Active',
                                  style: AppTypography.labelSm.copyWith(fontSize: 10),
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
          const SizedBox(height: 24),

          // Active Classes Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Active Classes',
                    style: AppTypography.headlineSm.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'Offline Sync Ready',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Classes Cards Stack
          ...classes.map((cls) {
            final isPrimary = cls.id == 'cs301';
            final accentColor = isPrimary ? AppColors.primary : AppColors.secondary;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MeshCard(
                padding: const EdgeInsets.all(16),
                leftBorderColor: accentColor,
                leftBorderWidth: 4,
                onTap: () {
                  appState.setTab(NavigationTab.classes);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: accentColor.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      cls.code,
                                      style: AppTypography.labelSm.copyWith(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.group, size: 13, color: AppColors.secondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${cls.peerCount} peers in mesh',
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cls.name,
                                style: AppTypography.headlineSm.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${cls.professor} • ${cls.location}',
                                style: AppTypography.bodySm,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: AppColors.onSurface,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    if (cls.nextLabTitle != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: AppColors.faintBorder)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.assignment_outlined,
                                    size: 15,
                                    color: accentColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      cls.nextLabTitle!,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              cls.nextLabTime ?? '',
                              style: AppTypography.labelSm.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (cls.readingTitle != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: AppColors.faintBorder)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.terminal,
                                    size: 15,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      cls.readingTitle!,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              cls.readingTime ?? '',
                              style: AppTypography.labelSm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // Professor Broadcasts Feed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.campaign, size: 22, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Professor Broadcasts',
                    style: AppTypography.headlineSm.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Text(
                'Live P2P Feed',
                style: AppTypography.labelSm,
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...announcements.map((ann) {
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
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  ann.authorInitials,
                                  style: AppTypography.headlineSm.copyWith(
                                    fontSize: 14,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      ann.authorName,
                                      style: AppTypography.bodyMd.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceContainer,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        ann.classCode,
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ann.timeAgo,
                                  style: AppTypography.bodySm.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '"${ann.body}"',
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified, size: 14, color: AppColors.secondary),
                            const SizedBox(width: 4),
                            Text(
                              'Verified Broadcast',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${ann.ackCount} Acknowledgments',
                          style: AppTypography.labelSm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // Recent Conversations Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.chat_bubble, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Conversations',
                    style: AppTypography.headlineSm.copyWith(fontSize: 18),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => appState.setTab(NavigationTab.messages),
                child: Text(
                  'View All',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...threads.take(2).map((thread) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MeshCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                onTap: () {
                  messageState.openThread(thread);
                  appState.setTab(NavigationTab.messages);
                },
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              thread.initials,
                              style: AppTypography.headlineSm.copyWith(
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        if (thread.isOnline)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.surface, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                thread.peerName,
                                style: AppTypography.bodyMd.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                thread.lastTime,
                                style: AppTypography.labelSm.copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            thread.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                    ),
                    if (thread.unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            thread.unreadCount.toString(),
                            style: const TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  void _showMeshIdDialog(BuildContext context, String meshId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            'Decentralized Mesh ID',
            style: AppTypography.headlineSm,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 120,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              meshId,
              style: AppTypography.codeBadge.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'Share with nearby classmates to establish direct Bluetooth or Wi-Fi relay link.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
