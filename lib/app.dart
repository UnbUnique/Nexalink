import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'state/app_state.dart';
import 'presentation/welcome/welcome_screen.dart';
import 'presentation/auth/student_login_screen.dart';
import 'presentation/auth/teacher_login_screen.dart';
import 'presentation/main_shell.dart';

class CampusMeshApp extends StatelessWidget {
  const CampusMeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const _AppRootView(),
    );
  }
}

class _AppRootView extends StatelessWidget {
  const _AppRootView();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    Widget currentScreen;
    switch (appState.currentScreen) {
      case AppScreen.welcome:
        currentScreen = const WelcomeScreen();
        break;
      case AppScreen.studentLogin:
        currentScreen = const StudentLoginScreen();
        break;
      case AppScreen.teacherLogin:
        currentScreen = const TeacherLoginScreen();
        break;
      case AppScreen.mainShell:
        currentScreen = const MainShell();
        break;
    }

    return Container(
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: currentScreen,
        ),
      ),
    );
  }
}
