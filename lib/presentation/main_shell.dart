import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/widgets/mesh_app_bar.dart';
import '../core/widgets/mesh_bottom_nav.dart';
import '../state/app_state.dart';
import 'dashboard/student_dashboard_view.dart';
import 'dashboard/teacher_dashboard_view.dart';
import 'classes/class_selection_screen.dart';
import 'devices/connected_devices_screen.dart';
import 'messages/message_history_screen.dart';
import 'announcements/send_announcement_screen.dart';
import 'alerts/urgent_alert_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _showingBroadcastComposer = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentTab = appState.currentTab;
    final currentRole = appState.currentRole;

    Widget bodyContent;

    if (_showingBroadcastComposer) {
      bodyContent = SendAnnouncementScreen(
        onBack: () {
          setState(() {
            _showingBroadcastComposer = false;
          });
        },
      );
    } else {
      switch (currentTab) {
        case NavigationTab.dashboard:
          bodyContent = currentRole == UserRole.teacher
              ? TeacherDashboardView(
                  onBroadcastTap: () {
                    setState(() {
                      _showingBroadcastComposer = true;
                    });
                  },
                )
              : const StudentDashboardView();
          break;
        case NavigationTab.classes:
          bodyContent = const ClassSelectionScreen();
          break;
        case NavigationTab.messages:
          bodyContent = const MessageHistoryScreen();
          break;
        case NavigationTab.devices:
          bodyContent = const ConnectedDevicesScreen();
          break;
        case NavigationTab.alerts:
          bodyContent = const UrgentAlertScreen();
          break;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const MeshAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: bodyContent,
        ),
      ),
      bottomNavigationBar: const MeshBottomNav(),
    );
  }
}
