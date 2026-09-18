import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/mesh_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../state/message_state.dart';
import '../../data/models/chat_message.dart';
import 'chat_conversation_sheet.dart';

class MessageHistoryScreen extends StatefulWidget {
  const MessageHistoryScreen({super.key});

  @override
  State<MessageHistoryScreen> createState() => _MessageHistoryScreenState();
}

class _MessageHistoryScreenState extends State<MessageHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [
    'All Threads',
    'Direct P2P',
    'Mesh Broadcasts',
    'Sync Queue',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChatModal(BuildContext context, ChatThread thread, MessageState state) {
    state.openThread(thread);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ChatConversationSheet(
        thread: thread,
        onClose: () {
          state.closeThread();
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messageState = context.watch<MessageState>();
    final threads = messageState.threads;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.faintBorder),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: AppColors.outline, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: AppTypography.bodyMd,
                    decoration: InputDecoration(
                      hintText: 'Search offline chats, broadcasts, peers...',
                      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.outline),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.tune, color: AppColors.secondary, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Quick Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = messageState.activeFilter == filter;
                final isSyncQueue = filter == 'Sync Queue';

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => messageState.setFilter(filter),
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.faintBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isSyncQueue) ...[
                            const PulseIndicator(color: AppColors.secondary, size: 5),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            filter,
                            style: AppTypography.labelMd.copyWith(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : (isSyncQueue ? AppColors.secondary : AppColors.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // Active Mesh Broadcast Log Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.faintBorder),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.tealGlow,
                  blurRadius: 18,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.radar, size: 18, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'MESH BROADCAST LOG',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '100% Synced',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'CS302 Architecture Study Group',
                  style: AppTypography.headlineSm.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prof. Vance: Don\'t forget the Bluetooth mesh fallback demo in lab today. Bring your ESP32 boards!',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'PV',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.onPrimaryContainer,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Dr. Alan Vance • Broadcast to 34 peers',
                          style: AppTypography.bodySm.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                    Text(
                      '12:42 PM',
                      style: AppTypography.labelSm.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent Conversations Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Conversations',
                style: AppTypography.headlineSm.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'P2P Encrypted',
                style: AppTypography.labelSm,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Threads List
          ...threads.map((thread) {
            final isSyncing = thread.syncPercentage < 100;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MeshCard(
                padding: const EdgeInsets.all(14),
                onTap: () => _openChatModal(context, thread, messageState),
                child: Row(
                  children: [
                    // Avatar / Icon Stack
                    Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: thread.initials == 'R4'
                                ? const Icon(Icons.hub,
                                    color: AppColors.secondary, size: 22)
                                : (thread.initials == 'PH'
                                    ? const Icon(Icons.science,
                                        color: AppColors.primary, size: 22)
                                    : Text(
                                        thread.initials,
                                        style: AppTypography.headlineSm.copyWith(
                                          fontSize: 15,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: thread.isOnline
                                  ? AppColors.secondary
                                  : AppColors.outline,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surface, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Peer name & snippet
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                thread.peerName,
                                style: AppTypography.headlineSm.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                thread.lastTime,
                                style: AppTypography.labelSm.copyWith(
                                  fontSize: 10,
                                  color: thread.unreadCount > 0
                                      ? AppColors.secondary
                                      : AppColors.outline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            thread.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              color: thread.unreadCount > 0
                                  ? AppColors.onSurface
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Trailing: Unread badge or Sync %
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (thread.unreadCount > 0) ...[
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
                          const SizedBox(height: 4),
                        ],
                        if (isSyncing)
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${thread.syncPercentage}%',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              const Icon(Icons.done_all,
                                  size: 13, color: AppColors.secondary),
                              const SizedBox(width: 2),
                              Text(
                                '100%',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
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
