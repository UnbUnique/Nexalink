import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../data/models/course_class.dart';
import '../data/models/announcement.dart';
import '../data/models/urgent_alert.dart';
import '../data/mock/mock_data.dart';

class BroadcastState extends ChangeNotifier {
  List<CourseClass> _classes = MockData.initialClasses;
  List<Announcement> _studentAnnouncements = MockData.studentAnnouncements;
  List<Announcement> _teacherAnnouncements = MockData.teacherAnnouncements;
  UrgentAlertModel _urgentAlert = MockData.defaultUrgentAlert;

  bool _isSwitchingClass = false;
  String? _switchingClassId;

  // Broadcasting broadcast simulator
  bool _isBroadcasting = false;
  double _broadcastProgress = 0.0;
  String _broadcastStatusTitle = 'Broadcasting Packet...';
  String _broadcastBadge = 'Hop 0/3';
  String _broadcastStatusMessage = 'Initializing local radio broadcast...';
  String _broadcastAckCount = '0 / 42 peers ACKed';

  List<CourseClass> get classes => _classes;
  CourseClass get activeClass =>
      _classes.firstWhere((c) => c.isCurrentActive, orElse: () => _classes.first);
  List<Announcement> get studentAnnouncements => _studentAnnouncements;
  List<Announcement> get teacherAnnouncements => _teacherAnnouncements;
  UrgentAlertModel get urgentAlert => _urgentAlert;

  bool get isSwitchingClass => _isSwitchingClass;
  String? get switchingClassId => _switchingClassId;

  bool get isBroadcasting => _isBroadcasting;
  double get broadcastProgress => _broadcastProgress;
  String get broadcastStatusTitle => _broadcastStatusTitle;
  String get broadcastBadge => _broadcastBadge;
  String get broadcastStatusMessage => _broadcastStatusMessage;
  String get broadcastAckCount => _broadcastAckCount;

  Future<void> switchActiveClass(String classId) async {
    if (_isSwitchingClass) return;

    _isSwitchingClass = true;
    _switchingClassId = classId;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1100));

    _classes = _classes.map((c) {
      return c.copyWith(
        isCurrentActive: c.id == classId,
        syncStatusText: c.id == classId ? '100% Synced' : 'Standby',
        syncPercentage: c.id == classId ? 100 : 85,
      );
    }).toList();

    _isSwitchingClass = false;
    _switchingClassId = null;
    notifyListeners();
  }

  Future<bool> broadcastAnnouncement({
    required String title,
    required String body,
    required String classCode,
    required AnnouncementUrgency urgency,
    required bool multiHop,
    required String authorName,
  }) async {
    if (_isBroadcasting) return false;

    _isBroadcasting = true;
    _broadcastProgress = 0.15;
    _broadcastStatusTitle = 'Broadcasting Packet...';
    _broadcastBadge = 'Hop 1/3';
    _broadcastStatusMessage = 'Relaying through direct Bluetooth LE peers...';
    _broadcastAckCount = '8 / 42 peers ACKed';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));
    _broadcastProgress = 0.55;
    _broadcastBadge = 'Hop 2/3';
    _broadcastStatusMessage = 'Packet relayed over Wi-Fi Direct subnet...';
    _broadcastAckCount = '26 / 42 peers ACKed';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));
    _broadcastProgress = 1.0;
    _broadcastBadge = 'Delivered';
    _broadcastStatusTitle = 'Broadcast Complete!';
    _broadcastStatusMessage = 'Verified reception across all local mesh nodes.';
    _broadcastAckCount = '42 / 42 peers ACKed';

    final newAnnouncement = Announcement(
      id: 'ann-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      authorName: authorName,
      authorInitials: authorName.isNotEmpty ? authorName.substring(0, 2).toUpperCase() : 'ME',
      classCode: classCode,
      timeAgo: 'Just now via Direct Mesh',
      ackCount: 42,
      urgency: urgency,
      deliveryChannel: 'Mesh Broadcast',
      syncPercentage: 100,
    );

    _teacherAnnouncements = [newAnnouncement, ..._teacherAnnouncements];
    _studentAnnouncements = [newAnnouncement, ..._studentAnnouncements];
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));
    _isBroadcasting = false;
    _broadcastProgress = 0.0;
    notifyListeners();
    return true;
  }

  void acknowledgeAlert() {
    _urgentAlert = _urgentAlert.copyWith(isAcknowledged: true);
    notifyListeners();
  }
}
