import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../data/models/user_profile.dart';
import '../data/mock/mock_data.dart';

enum AppScreen {
  welcome,
  studentLogin,
  teacherLogin,
  mainShell,
}

class AppState extends ChangeNotifier {
  AppScreen _currentScreen = AppScreen.welcome;
  UserRole _currentRole = UserRole.student;
  UserProfile _currentUser = MockData.studentUser;
  NavigationTab _currentTab = NavigationTab.dashboard;

  AppScreen get currentScreen => _currentScreen;
  UserRole get currentRole => _currentRole;
  UserProfile get currentUser => _currentUser;
  NavigationTab get currentTab => _currentTab;
  bool get isLoggedIn => _currentScreen == AppScreen.mainShell;

  void selectRole(UserRole role) {
    _currentRole = role;
    if (role == UserRole.teacher) {
      _currentScreen = AppScreen.teacherLogin;
    } else {
      _currentScreen = AppScreen.studentLogin;
    }
    notifyListeners();
  }

  void goToWelcome() {
    _currentScreen = AppScreen.welcome;
    notifyListeners();
  }

  void login(UserRole role) {
    _currentRole = role;
    _currentUser = (role == UserRole.teacher)
        ? MockData.teacherUser
        : MockData.studentUser;
    _currentScreen = AppScreen.mainShell;
    _currentTab = NavigationTab.dashboard;
    notifyListeners();
  }

  void switchRole(UserRole role) {
    _currentRole = role;
    _currentUser = (role == UserRole.teacher)
        ? MockData.teacherUser
        : MockData.studentUser;
    notifyListeners();
  }

  void logout() {
    _currentScreen = AppScreen.welcome;
    _currentTab = NavigationTab.dashboard;
    notifyListeners();
  }

  void setTab(NavigationTab tab) {
    _currentTab = tab;
    notifyListeners();
  }
}
