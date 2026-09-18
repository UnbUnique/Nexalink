import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/mesh_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../state/broadcast_state.dart';

class ClassSelectionScreen extends StatefulWidget {
  const ClassSelectionScreen({super.key});

  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final broadcastState = context.watch<BroadcastState>();
    final classes = broadcastState.classes.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q) ||
          c.professor.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mesh Status Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
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
                        const PulseIndicator(color: AppColors.secondary, size: 6),
                        const SizedBox(width: 8),
                        Text(
                          'LOCAL MESH BROADCASTING',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'BT-LE / Wi-Fi Direct',
                      style: AppTypography.labelSm,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'You are connected to 3 local relays. Switch your active mesh channel to sync lecture notes and join peer study groups instantly.',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurface,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search & Filter Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.faintBorder),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: AppTypography.bodyMd,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.outline,
                        size: 20,
                      ),
                      hintText: 'Search classes, codes, or professors...',
                      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.outline),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.faintBorder),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune, color: AppColors.onSurface, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filter options: All, Undergrad, Graduate, Labs')),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Class Cards Stack
          ...classes.map((cls) {
            final isActive = cls.isCurrentActive;
            final isSwitchingThis =
                broadcastState.isSwitchingClass && broadcastState.switchingClassId == cls.id;

            IconData classIcon;
            if (cls.code.contains('301')) {
              classIcon = Icons.terminal;
            } else if (cls.code.contains('350')) {
              classIcon = Icons.dns;
            } else {
              classIcon = Icons.science;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.surfaceContainerHigh
                      : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary.withOpacity(0.3)
                        : AppColors.faintBorder,
                  ),
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: AppColors.purpleGlow,
                            blurRadius: 18,
                            offset: Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code + Badges + Icon
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
                                      color: isActive
                                          ? AppColors.primaryContainer.withOpacity(0.3)
                                          : AppColors.surfaceBright,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      cls.code,
                                      style: AppTypography.labelSm.copyWith(
                                        color: isActive
                                            ? AppColors.primary
                                            : AppColors.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (isActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryContainer
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Row(
                                        children: [
                                          const PulseIndicator(
                                              color: AppColors.secondary, size: 5),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Active Channel',
                                            style: AppTypography.labelSm.copyWith(
                                              color: AppColors.secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceBright,
                                        borderRadius: BorderRadius.circular(9999),
                                      ),
                                      child: Text(
                                        'Standby',
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cls.name,
                                style: AppTypography.headlineMd.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary.withOpacity(0.2)
                                : AppColors.surfaceBright,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            classIcon,
                            color: isActive ? AppColors.primary : AppColors.onSurface,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${cls.professor} • ${cls.location} • Zero-internet local subnet',
                      style: AppTypography.bodySm,
                    ),
                    const SizedBox(height: 16),

                    // Stats Grid: Peer Density & Sync Status
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.surfaceContainer
                                  : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Peer Density',
                                  style: AppTypography.labelSm.copyWith(fontSize: 10),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.wifi_tethering,
                                        size: 16, color: AppColors.secondary),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${cls.peerCount} peers',
                                      style: AppTypography.headlineSm.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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
                              color: isActive
                                  ? AppColors.surfaceContainer
                                  : AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sync Status',
                                  style: AppTypography.labelSm.copyWith(fontSize: 10),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      isActive ? Icons.cloud_done : Icons.sync,
                                      size: 16,
                                      color: isActive
                                          ? AppColors.primary
                                          : AppColors.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        cls.syncStatusText,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.headlineSm.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 16),

                    // Action Button (Active vs Switch)
                    if (isActive)
                      Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.radio_button_checked,
                                size: 18, color: AppColors.onPrimary),
                            const SizedBox(width: 8),
                            Text(
                              'Current Active Mesh',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceBright,
                            foregroundColor: AppColors.onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isSwitchingThis
                              ? null
                              : () {
                                  broadcastState.switchActiveClass(cls.id);
                                },
                          child: isSwitchingThis
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Connecting...',
                                      style: AppTypography.labelMd,
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.swap_horiz, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Switch Active Class',
                                      style: AppTypography.labelMd.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),

          // Discovery Footer Card
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.radar,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Looking for another class?',
                        style: AppTypography.headlineSm.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Scan nearby Bluetooth beacons for unlisted seminar pods.',
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.onSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scanning Bluetooth beacons... Found 2 pods in range.'),
                      ),
                    );
                  },
                  child: Text(
                    'Scan',
                    style: AppTypography.labelSm.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
