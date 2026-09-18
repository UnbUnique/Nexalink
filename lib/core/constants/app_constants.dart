enum UserRole {
  student,
  teacher,
}

enum NavigationTab {
  dashboard,
  classes,
  messages,
  devices,
  alerts,
}

enum AnnouncementUrgency {
  normal,
  important,
  emergency,
}

class AppConstants {
  AppConstants._();

  static const String appName = 'CampusMesh';
  static const String appSubtitle = 'Decentralized Academic Network';
  static const String defaultMeshNodeId = '#mesh-8821-x';
  static const String localKey = '#8F2A';
  static const int initialPeerCount = 4;
}
