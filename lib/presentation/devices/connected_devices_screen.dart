import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/mesh_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../core/widgets/mesh_radar_widget.dart';
import '../../state/mesh_network_state.dart';
import '../../data/models/mesh_node.dart';

class ConnectedDevicesScreen extends StatelessWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meshState = context.watch<MeshNetworkState>();
    final nodes = meshState.nodes;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Titles
          Text(
            'Mesh Topology',
            style: AppTypography.headlineLgMobile.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Decentralized P2P mesh active. Relaying through 4 local peers.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 18),

          // Core Node Status Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.faintBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.hub,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NexaLink Core',
                              style: AppTypography.headlineSm.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Node ID: ${meshState.nodeId}',
                              style: AppTypography.bodySm,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        children: [
                          const PulseIndicator(
                              color: AppColors.secondary, size: 6),
                          const SizedBox(width: 6),
                          Text(
                            'SYNCED',
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
                const SizedBox(height: 16),

                // 3-Metric Subnet Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PEERS',
                              style: AppTypography.labelSm.copyWith(fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${meshState.activePeerCount} Active',
                              style: AppTypography.headlineSm.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BANDWIDTH',
                              style: AppTypography.labelSm.copyWith(fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meshState.bandwidth,
                              style: AppTypography.headlineSm.copyWith(
                                fontSize: 14,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PACKET LOSS',
                              style: AppTypography.labelSm.copyWith(fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meshState.packetLoss,
                              style: AppTypography.headlineSm.copyWith(
                                fontSize: 14,
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
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Network Radar Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Network Radar',
                style: AppTypography.headlineSm.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'LIVE TOPOLOGY',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Custom Radar Canvas
          MeshRadarWidget(
            nodes: nodes,
            onNodeSelected: (node) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${node.name} (${node.typeLabel}) • RSSI: ${node.rssiDbm} dBm • ${node.protocolLabel}'),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Scan for New Peers Action Button
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
              onPressed: meshState.isScanning
                  ? null
                  : () {
                      meshState.triggerScan();
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (meshState.isScanning)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  else
                    const Icon(Icons.radar, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    meshState.scanStatusText,
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
          const SizedBox(height: 24),

          // Connected Nodes List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Connected Nodes',
                style: AppTypography.headlineSm.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${nodes.length} DEVICES',
                style: AppTypography.labelSm,
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...nodes.map((node) {
            Color badgeBg;
            Color badgeColor;
            IconData roleIcon;

            if (node.type == NodeType.teacher) {
              badgeBg = AppColors.secondaryContainer.withOpacity(0.2);
              badgeColor = AppColors.secondary;
              roleIcon = Icons.school;
            } else if (node.type == NodeType.student) {
              badgeBg = AppColors.primaryContainer.withOpacity(0.25);
              badgeColor = AppColors.primary;
              roleIcon = Icons.person;
            } else {
              badgeBg = AppColors.surfaceContainerHigh;
              badgeColor = AppColors.onSurfaceVariant;
              roleIcon = Icons.router;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MeshCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(roleIcon, color: badgeColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                node.name,
                                style: AppTypography.bodyMd.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  node.typeLabel,
                                  style: AppTypography.labelSm.copyWith(
                                    color: badgeColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${node.protocolLabel} • ${node.hops == 0 ? "Direct" : "${node.hops} Hops"} • RSSI ${node.rssiDbm} dBm',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              node.batteryPercent > 80
                                  ? Icons.battery_full
                                  : Icons.battery_3_bar,
                              size: 15,
                              color: badgeColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${node.batteryPercent}%',
                              style: AppTypography.labelSm.copyWith(
                                color: badgeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: badgeColor,
                            shape: BoxShape.circle,
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
