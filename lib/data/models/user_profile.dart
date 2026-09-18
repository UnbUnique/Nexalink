import '../../core/constants/app_constants.dart';

class UserProfile {
  final String id;
  final String name;
  final UserRole role;
  final String department;
  final String titleOrYear;
  final String? avatarUrl;
  final String meshId;
  final String email;

  const UserProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.titleOrYear,
    this.avatarUrl,
    required this.meshId,
    required this.email,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
  }
}
