import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_constants.dart';
import '../../state/app_state.dart';
import '../../state/mesh_network_state.dart';
import 'pulse_indicator.dart';

class MeshAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onProfileTap;

  const MeshAppBar({
    super.key,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final meshState = context.watch<MeshNetworkState>();

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xCC111317), // 80% opacity
        border: Border(
          bottom: BorderSide(color: AppColors.faintBorder),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo + App Name
            GestureDetector(
              onTap: () {
                appState.setTab(NavigationTab.dashboard);
              },
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryContainer, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.purpleGlow,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.hub,
                      color: AppColors.surface,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppConstants.appName,
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Right Items: Mesh Status Pill + Profile Circle
            Row(
              children: [
                // Mesh Node Peer Badge
                GestureDetector(
                  onTap: () {
                    appState.setTab(NavigationTab.devices);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: AppColors.outlineVariant.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PulseIndicator(
                          color: AppColors.secondary,
                          size: 6,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'MESH ${meshState.activePeerCount} PEERS',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // User Profile Button
                GestureDetector(
                  onTap: () {
                    if (onProfileTap != null) {
                      onProfileTap!();
                    } else {
                      _showProfileModal(context, appState);
                    }
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        appState.currentUser.initials,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileModal(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final isStudent = appState.currentRole == UserRole.student;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        appState.currentUser.initials,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.currentUser.name,
                          style: AppTypography.headlineSm,
                        ),
                        Text(
                          '${appState.currentUser.department} • ${appState.currentUser.titleOrYear}',
                          style: AppTypography.bodySm,
                        ),
                        Text(
                          'Node ID: ${appState.currentUser.meshId}',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Switch Profile / Persona',
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isStudent
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        foregroundColor: isStudent
                            ? AppColors.onPrimary
                            : AppColors.onSurface,
                      ),
                      onPressed: () {
                        appState.switchRole(UserRole.student);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Student Mode'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isStudent
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        foregroundColor: !isStudent
                            ? AppColors.onPrimary
                            : AppColors.onSurface,
                      ),
                      onPressed: () {
                        appState.switchRole(UserRole.teacher);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Faculty Mode'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  side: const BorderSide(color: AppColors.outlineVariant),
                  foregroundColor: AppColors.onSurfaceVariant,
                ),
                onPressed: () {
                  appState.logout();
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out to Welcome'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
