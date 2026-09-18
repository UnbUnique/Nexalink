import '../../core/constants/app_constants.dart';
import '../models/user_profile.dart';
import '../models/course_class.dart';
import '../models/announcement.dart';
import '../models/mesh_node.dart';
import '../models/chat_message.dart';
import '../models/urgent_alert.dart';

class MockData {
  MockData._();

  static const UserProfile studentUser = UserProfile(
    id: 'stu-2024-8842',
    name: 'Alex Chen',
    role: UserRole.student,
    department: 'Computer Science Dept',
    titleOrYear: 'Junior',
    meshId: 'STU-2024-8842',
    email: 'alex.chen@campus.edu',
  );

  static const UserProfile teacherUser = UserProfile(
    id: 'fac-9912-4410',
    name: 'Dr. Alan Grant',
    role: UserRole.teacher,
    department: 'Paleo-Lab Sector B',
    titleOrYear: 'Senior Faculty',
    meshId: 'FAC-9912-4410',
    email: 'teacher@campus.edu',
  );

  static List<CourseClass> get initialClasses => [
        const CourseClass(
          id: 'cs301',
          code: 'CS-301',
          name: 'Data Structures & Algorithms',
          professor: 'Prof. Alan Turing',
          location: 'Hall 4B',
          peerCount: 48,
          syncPercentage: 100,
          isCurrentActive: true,
          syncStatusText: '100% Synced',
          nextLabTitle: 'Next Lab: AVL Trees & Self-Balancing Maps',
          nextLabTime: 'Today, 2:00 PM',
        ),
        const CourseClass(
          id: 'cs350',
          code: 'CS-350',
          name: 'Operating Systems',
          professor: 'Dr. Grace Hopper',
          location: 'Science Wing 2',
          peerCount: 24,
          syncPercentage: 82,
          isCurrentActive: false,
          syncStatusText: '82% (Syncing)',
          readingTitle: 'Reading: Virtual Memory & Page Faults',
          readingTime: 'Tomorrow',
        ),
        const CourseClass(
          id: 'phys201',
          code: 'PHYS-201',
          name: 'Quantum Mechanics',
          professor: 'Prof. Richard Feynman',
          location: 'Lecture Hall 1',
          peerCount: 12,
          syncPercentage: 100,
          isCurrentActive: false,
          syncStatusText: 'Cached',
        ),
      ];

  static List<Announcement> get studentAnnouncements => [
        const Announcement(
          id: 'ann-1',
          title: 'Lab 4 Shifted to Offline Peer Mode',
          body:
              'Reminder: Today\'s lab on Red-Black trees has been shifted to offline peer collaboration mode due to campus Wi-Fi maintenance. Make sure your NexaLink daemon is synced before entering Hall B.',
          authorName: 'Prof. Alan Turing',
          authorInitials: 'AT',
          classCode: 'CS 301',
          timeAgo: '10 minutes ago via Mesh Relay',
          ackCount: 42,
          isVerified: true,
          urgency: AnnouncementUrgency.normal,
          deliveryChannel: 'Mesh Relay',
          syncPercentage: 100,
        ),
        const Announcement(
          id: 'ann-2',
          title: 'Kernel Module Starter Code Published',
          body:
              'The kernel module starter code has been published to the local mesh repository. You can pull it instantly from any peer in Lab 4 without an internet connection.',
          authorName: 'Prof. Ada Lovelace',
          authorInitials: 'AL',
          classCode: 'CS 350',
          timeAgo: '2 hours ago via Direct Node',
          ackCount: 28,
          isVerified: true,
          urgency: AnnouncementUrgency.normal,
          deliveryChannel: 'Direct Node',
          syncPercentage: 100,
        ),
      ];

  static List<Announcement> get teacherAnnouncements => [
        const Announcement(
          id: 'teach-ann-1',
          title: 'Field Trip Relocated to Sector 4 Raptor Paddock',
          body:
              'Due to high grass density and potential nesting activity, today\'s fossil collection will take place near the perimeter fence. Bring extra water.',
          authorName: 'Dr. Alan Grant',
          authorInitials: 'AG',
          classCode: 'PALEO-301',
          timeAgo: '10m ago',
          ackCount: 22,
          isVerified: true,
          urgency: AnnouncementUrgency.important,
          deliveryChannel: 'Delivered to 22 peer nodes',
          syncPercentage: 100,
        ),
        const Announcement(
          id: 'teach-ann-2',
          title: 'Mesh Router Node #12 Battery Low',
          body:
              'Secondary relay in the Amber Hallway is operating on backup solar power. Please avoid connecting heavy data streams to this specific relay.',
          authorName: 'IT Department Alert',
          authorInitials: 'IT',
          classCode: 'SYSTEM NOTICE',
          timeAgo: '1h ago',
          ackCount: 19,
          isVerified: true,
          urgency: AnnouncementUrgency.normal,
          deliveryChannel: 'IT Department Alert',
          syncPercentage: 100,
        ),
      ];

  static List<MeshNode> get meshNodes => [
        const MeshNode(
          id: 'node-1',
          name: 'Prof. Eleanor Vance',
          type: NodeType.teacher,
          protocol: ConnectionProtocol.wifiDirect,
          hops: 1,
          rssiDbm: -48,
          batteryPercent: 94,
          isOnline: true,
          radarAngle: 2.3,
          radarDistance: 0.72,
        ),
        const MeshNode(
          id: 'node-2',
          name: 'Alex Rivera',
          type: NodeType.student,
          protocol: ConnectionProtocol.bluetoothLe,
          hops: 0,
          rssiDbm: -62,
          batteryPercent: 82,
          isOnline: true,
          radarAngle: 5.4,
          radarDistance: 0.65,
        ),
        const MeshNode(
          id: 'node-3',
          name: 'Maya Lin',
          type: NodeType.student,
          protocol: ConnectionProtocol.wifiDirect,
          hops: 2,
          rssiDbm: -78,
          batteryPercent: 18,
          isOnline: true,
          radarAngle: 0.8,
          radarDistance: 0.55,
        ),
        const MeshNode(
          id: 'node-4',
          name: 'Relay Node 04',
          type: NodeType.relay,
          protocol: ConnectionProtocol.wifiDirect,
          hops: 1,
          rssiDbm: -55,
          batteryPercent: 100,
          isOnline: true,
          radarAngle: 3.7,
          radarDistance: 0.80,
        ),
        const MeshNode(
          id: 'node-5',
          name: 'Alex K.',
          type: NodeType.student,
          protocol: ConnectionProtocol.bluetoothLe,
          hops: 1,
          rssiDbm: -65,
          batteryPercent: 88,
          isOnline: true,
          radarAngle: 4.8,
          radarDistance: 0.60,
        ),
        const MeshNode(
          id: 'node-6',
          name: 'Study Pod 3 Relay',
          type: NodeType.relay,
          protocol: ConnectionProtocol.wifiDirect,
          hops: 2,
          rssiDbm: -82,
          batteryPercent: 74,
          isOnline: true,
          radarAngle: 1.6,
          radarDistance: 0.88,
        ),
      ];

  static List<ChatThread> get initialChatThreads => [
        ChatThread(
          id: 'thread-maya',
          peerName: 'Maya Lin',
          initials: 'ML',
          lastMessage:
              'Can you send over the wireless protocol notes? My Bluetooth dropped...',
          lastTime: '10:15 AM',
          unreadCount: 2,
          syncPercentage: 100,
          isOnline: true,
          messages: [
            const ChatMessage(
              id: 'm-1',
              senderId: 'maya',
              senderName: 'Maya Lin',
              senderInitials: 'ML',
              text:
                  'Hey! Are you connected to the library peer mesh right now? My data dropped completely in the basement stack.',
              timestamp: '10:12 AM',
              isMe: false,
            ),
            const ChatMessage(
              id: 'm-2',
              senderId: 'me',
              senderName: 'Alex Chen',
              senderInitials: 'AC',
              text:
                  'Yeah I\'m on the mesh relay! Connected via Bluetooth bridge to node #4. What do you need?',
              timestamp: '10:14 AM',
              isMe: true,
            ),
            const ChatMessage(
              id: 'm-3',
              senderId: 'maya',
              senderName: 'Maya Lin',
              senderInitials: 'ML',
              text:
                  'Can you send over the wireless protocol notes? My Bluetooth dropped right before she explained it!',
              timestamp: '10:15 AM',
              isMe: false,
            ),
          ],
        ),
        ChatThread(
          id: 'thread-study-cs301',
          peerName: 'Study Group: CS301',
          initials: 'SG',
          lastMessage: 'Sarah: Anyone have the notes for AVL rotations?',
          lastTime: '12:45 PM',
          unreadCount: 2,
          syncPercentage: 100,
          isOnline: true,
          isDirect: false,
          messages: [
            const ChatMessage(
              id: 'sg-1',
              senderId: 'sarah',
              senderName: 'Sarah',
              senderInitials: 'SK',
              text: 'Anyone have the notes for AVL rotations?',
              timestamp: '12:45 PM',
              isMe: false,
            ),
          ],
        ),
        ChatThread(
          id: 'thread-relay4',
          peerName: 'NexaLink Relay 4',
          initials: 'R4',
          lastMessage:
              'Packet transfer complete: 14 nodes synchronized successfully.',
          lastTime: 'Yesterday',
          unreadCount: 0,
          syncPercentage: 100,
          isOnline: true,
          isDirect: false,
          messages: [
            const ChatMessage(
              id: 'r4-1',
              senderId: 'relay4',
              senderName: 'Relay 4',
              senderInitials: 'R4',
              text:
                  'Packet transfer complete: 14 nodes synchronized successfully.',
              timestamp: 'Yesterday',
              isMe: false,
            ),
          ],
        ),
        ChatThread(
          id: 'thread-marcus',
          peerName: 'Marcus Vance',
          initials: 'MV',
          lastMessage:
              'Thanks for sharing the library offline cache! Saved my assignment.',
          lastTime: 'Yesterday',
          unreadCount: 0,
          syncPercentage: 100,
          isOnline: false,
          messages: [
            const ChatMessage(
              id: 'mv-1',
              senderId: 'marcus',
              senderName: 'Marcus Vance',
              senderInitials: 'MV',
              text:
                  'Thanks for sharing the library offline cache! Saved my assignment.',
              timestamp: 'Yesterday',
              isMe: false,
            ),
          ],
        ),
        ChatThread(
          id: 'thread-phys',
          peerName: 'Physics 101 Subnet',
          initials: 'PH',
          lastMessage: 'Sarah: Anyone have problem set 4 solutions cached?',
          lastTime: 'Oct 22',
          unreadCount: 0,
          syncPercentage: 84,
          isOnline: true,
          isDirect: false,
          messages: [
            const ChatMessage(
              id: 'ph-1',
              senderId: 'sarah',
              senderName: 'Sarah',
              senderInitials: 'SK',
              text: 'Anyone have problem set 4 solutions cached?',
              timestamp: 'Oct 22',
              isMe: false,
            ),
          ],
        ),
      ];

  static UrgentAlertModel get defaultUrgentAlert => const UrgentAlertModel(
        id: 'alert-892',
        broadcastNumber: '#892',
        title: 'Campus-Wide Severe Weather / Safety Notice',
        description:
            'Flash flooding and high-velocity wind gusts reported near the Science Quad and North Residence Halls. All outdoor activities must cease immediately. Seek shelter in the nearest hardened building basement or ground-floor interior hallway until further notice. Do not attempt to cross low-lying pathways.',
        timeAgo: '2 mins ago via Peer Relay',
        source: 'Campus Safety Office',
        nodesSynced: 1420,
        isAcknowledged: false,
        sectors: [
          AffectedSector(
            id: 'sec-1',
            name: 'Science Quad & Labs',
            instruction: 'Immediate evacuation to higher floors required',
            severity: SectorSeverity.critical,
          ),
          AffectedSector(
            id: 'sec-2',
            name: 'North Residence Halls',
            instruction: 'Power fluctuations reported, stay indoors',
            severity: SectorSeverity.critical,
          ),
          AffectedSector(
            id: 'sec-3',
            name: 'Student Union & Dining',
            instruction: 'Functioning as designated secondary shelter',
            severity: SectorSeverity.shelter,
          ),
          AffectedSector(
            id: 'sec-4',
            name: 'Athletic Complex',
            instruction: 'All outdoor practices cancelled',
            severity: SectorSeverity.monitoring,
          ),
        ],
      );
}
