import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../state/broadcast_state.dart';
import '../../state/app_state.dart';

class SendAnnouncementScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SendAnnouncementScreen({super.key, this.onBack});

  @override
  State<SendAnnouncementScreen> createState() => _SendAnnouncementScreenState();
}

class _SendAnnouncementScreenState extends State<SendAnnouncementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  String _selectedClass = 'CS-301';
  AnnouncementUrgency _urgency = AnnouncementUrgency.normal;
  bool _multiHop = true;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _bodyController.addListener(() {
      setState(() {
        _charCount = _bodyController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _handleBroadcast(BroadcastState broadcastState, AppState appState) async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an announcement title')),
      );
      return;
    }

    final success = await broadcastState.broadcastAnnouncement(
      title: title,
      body: body.isNotEmpty ? body : 'Class notification broadcasted via mesh.',
      classCode: _selectedClass,
      urgency: _urgency,
      multiHop: _multiHop,
      authorName: appState.currentUser.name,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Broadcast successfully synced across 42 peer nodes!'),
        ),
      );
      _titleController.clear();
      _bodyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final broadcastState = context.watch<BroadcastState>();
    final appState = context.watch<AppState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Hub Banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.onBack != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
                  onPressed: widget.onBack,
                )
              else
                Text(
                  'BROADCAST HUB',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: AppColors.faintBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_tethering,
                        size: 14, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    Text(
                      '14 Peers in Range',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            'Send Mesh Announcement',
            style: AppTypography.headlineLgMobile.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Instant, offline-first peer broadcast over Wi-Fi Direct & Bluetooth LE.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),

          // Form Controls
          // Target Class Dropdown
          Text(
            'Target Class / Channel',
            style: AppTypography.labelMd.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.faintBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedClass,
                dropdownColor: AppColors.surfaceContainerHigh,
                icon: const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
                isExpanded: true,
                style: AppTypography.bodyMd,
                items: const [
                  DropdownMenuItem(
                    value: 'CS-301',
                    child: Text('CS 301: Advanced Data Structures (42 students)'),
                  ),
                  DropdownMenuItem(
                    value: 'CS-490',
                    child: Text('CS 490: Senior Capstone Mesh Project (18 students)'),
                  ),
                  DropdownMenuItem(
                    value: 'NET-101',
                    child: Text('NET 101: Intro to Decentralized Networks (65 students)'),
                  ),
                  DropdownMenuItem(
                    value: 'ALL',
                    child: Text('⚡ Broadcast to All Active Campus Peers'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedClass = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Priority Level Selector
          Text(
            'Priority Level',
            style: AppTypography.labelMd.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildUrgencyButton(
                title: 'Normal',
                dotColor: AppColors.secondary,
                targetUrgency: AnnouncementUrgency.normal,
              ),
              const SizedBox(width: 8),
              _buildUrgencyButton(
                title: 'Important',
                dotColor: AppColors.warning,
                targetUrgency: AnnouncementUrgency.important,
              ),
              const SizedBox(width: 8),
              _buildUrgencyButton(
                title: 'Emergency',
                dotColor: AppColors.emergencyVibrant,
                targetUrgency: AnnouncementUrgency.emergency,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Announcement Title
          Text(
            'Announcement Title',
            style: AppTypography.labelMd.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            style: AppTypography.bodyMd,
            decoration: InputDecoration(
              hintText: 'e.g., Lab 4 deadline extended by 24 hours',
              fillColor: AppColors.surfaceContainerHigh,
            ),
          ),
          const SizedBox(height: 18),

          // Message Body & Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Message Body',
                style: AppTypography.labelMd.copyWith(color: AppColors.onSurface),
              ),
              Text(
                '$_charCount / 500',
                style: AppTypography.labelSm.copyWith(
                  color: _charCount > 500 ? AppColors.error : AppColors.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _bodyController,
            maxLines: 4,
            style: AppTypography.bodyMd,
            decoration: InputDecoration(
              hintText:
                  'Type your broadcast message here. Will hop securely across nearby student devices...',
              fillColor: AppColors.surfaceContainerHigh,
            ),
          ),
          const SizedBox(height: 18),

          // Multi-hop Relay Switch
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.faintBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.hub, color: AppColors.secondary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Multi-hop Relay',
                        style: AppTypography.bodyMd.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Allow student devices to rebroadcast to offline zones',
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _multiHop,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _multiHop = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Broadcast to Mesh Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: broadcastState.isBroadcasting
                  ? null
                  : () => _handleBroadcast(broadcastState, appState),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.rss_feed, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Broadcast to Mesh',
                    style: AppTypography.headlineSm.copyWith(
                      fontSize: 16,
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Instant delivery via local Wi-Fi Direct & Bluetooth mesh packets',
              style: AppTypography.labelSm.copyWith(fontSize: 10),
            ),
          ),
          const SizedBox(height: 18),

          // Status Card during/after broadcast
          if (broadcastState.isBroadcasting)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            broadcastState.broadcastStatusTitle,
                            style: AppTypography.headlineSm.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          broadcastState.broadcastBadge,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: broadcastState.broadcastProgress,
                    backgroundColor: AppColors.surfaceContainerHighest,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                    borderRadius: BorderRadius.circular(9999),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          broadcastState.broadcastStatusMessage,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelSm,
                        ),
                      ),
                      Text(
                        broadcastState.broadcastAckCount,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildUrgencyButton({
    required String title,
    required Color dotColor,
    required AnnouncementUrgency targetUrgency,
  }) {
    final isSelected = _urgency == targetUrgency;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _urgency = targetUrgency;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.surfaceContainerHigh
                : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.faintBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.bodySm.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
