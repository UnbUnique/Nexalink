class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderInitials;
  final String text;
  final String timestamp;
  final bool isMe;
  final bool isMeshEncrypted;
  final int syncPercentage;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderInitials,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.isMeshEncrypted = true,
    this.syncPercentage = 100,
  });
}

class ChatThread {
  final String id;
  final String peerName;
  final String initials;
  final String lastMessage;
  final String lastTime;
  final int unreadCount;
  final int syncPercentage;
  final bool isOnline;
  final bool isDirect;
  final List<ChatMessage> messages;

  ChatThread({
    required this.id,
    required this.peerName,
    required this.initials,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
    this.syncPercentage = 100,
    this.isOnline = true,
    this.isDirect = true,
    required this.messages,
  });
}
