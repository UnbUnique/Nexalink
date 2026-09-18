import '../../core/constants/app_constants.dart';

class Announcement {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final String authorInitials;
  final String classCode;
  final String timeAgo;
  final int ackCount;
  final bool isVerified;
  final AnnouncementUrgency urgency;
  final String deliveryChannel;
  final int syncPercentage;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.authorInitials,
    required this.classCode,
    required this.timeAgo,
    required this.ackCount,
    this.isVerified = true,
    this.urgency = AnnouncementUrgency.normal,
    required this.deliveryChannel,
    this.syncPercentage = 100,
  });
}
