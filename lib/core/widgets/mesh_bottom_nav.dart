import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_constants.dart';
import '../../state/app_state.dart';
import '../../state/message_state.dart';
import '../../state/broadcast_state.dart';

class MeshBottomNav extends StatelessWidget {
  const MeshBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final messageState = context.watch<MessageState>();
    final broadcastState = context.watch<BroadcastState>();

    final currentTab = appState.currentTab;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xEE111317), // 90% opacity OLED background
        border: Border(
          top: BorderSide(color: AppColors.faintBorder),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              tab: NavigationTab.dashboard,
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'Dashboard',
              isSelected: currentTab == NavigationTab.dashboard,
              onTap: () => appState.setTab(NavigationTab.dashboard),
            ),
            _buildNavItem(
              tab: NavigationTab.classes,
              icon: Icons.school_outlined,
              activeIcon: Icons.school,
              label: 'Classes',
              isSelected: currentTab == NavigationTab.classes,
              onTap: () => appState.setTab(NavigationTab.classes),
            ),
            _buildNavItem(
              tab: NavigationTab.messages,
              icon: Icons.chat_bubble_outline,
              activeIcon: Icons.chat_bubble,
              label: 'Messages',
              isSelected: currentTab == NavigationTab.messages,
              badgeCount: messageState.totalUnreadCount,
              onTap: () => appState.setTab(NavigationTab.messages),
            ),
            _buildNavItem(
              tab: NavigationTab.devices,
              icon: Icons.wifi_tethering_outlined,
              activeIcon: Icons.wifi_tethering,
              label: 'Devices',
              isSelected: currentTab == NavigationTab.devices,
              onTap: () => appState.setTab(NavigationTab.devices),
            ),
            _buildNavItem(
              tab: NavigationTab.alerts,
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              label: 'Alerts',
              isSelected: currentTab == NavigationTab.alerts,
              hasWarningBadge: !broadcastState.urgentAlert.isAcknowledged,
              onTap: () => appState.setTab(NavigationTab.alerts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required NavigationTab tab,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    int badgeCount = 0,
    bool hasWarningBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 10,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            // Unread count badge
            if (badgeCount > 0)
              Positioned(
                top: 8,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Center(
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            // Urgent alert badge
            if (hasWarningBadge && tab == NavigationTab.alerts)
              Positioned(
                top: 8,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.emergencyVibrant,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
