import 'package:flutter/material.dart';
import '../data/models/chat_message.dart';
import '../data/mock/mock_data.dart';

class MessageState extends ChangeNotifier {
  List<ChatThread> _threads = MockData.initialChatThreads;
  String _activeFilter = 'All Threads';
  ChatThread? _activeThread;

  List<ChatThread> get threads {
    if (_activeFilter == 'Direct P2P') {
      return _threads.where((t) => t.isDirect).toList();
    } else if (_activeFilter == 'Mesh Broadcasts') {
      return _threads.where((t) => !t.isDirect).toList();
    } else if (_activeFilter == 'Sync Queue') {
      return _threads.where((t) => t.syncPercentage < 100).toList();
    }
    return _threads;
  }

  String get activeFilter => _activeFilter;
  ChatThread? get activeThread => _activeThread;

  int get totalUnreadCount =>
      _threads.fold(0, (sum, item) => sum + item.unreadCount);

  void setFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void openThread(ChatThread thread) {
    _activeThread = thread;
    // Mark thread as read
    final index = _threads.indexWhere((t) => t.id == thread.id);
    if (index != -1 && _threads[index].unreadCount > 0) {
      _threads[index] = ChatThread(
        id: thread.id,
        peerName: thread.peerName,
        initials: thread.initials,
        lastMessage: thread.lastMessage,
        lastTime: thread.lastTime,
        unreadCount: 0,
        syncPercentage: thread.syncPercentage,
        isOnline: thread.isOnline,
        isDirect: thread.isDirect,
        messages: thread.messages,
      );
      _activeThread = _threads[index];
    }
    notifyListeners();
  }

  void closeThread() {
    _activeThread = null;
    notifyListeners();
  }

  void sendMessage(String text) {
    if (_activeThread == null || text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'me',
      senderName: 'You',
      senderInitials: 'ME',
      text: text.trim(),
      timestamp: 'Just now',
      isMe: true,
      isMeshEncrypted: true,
      syncPercentage: 100,
    );

    final updatedMessages = List<ChatMessage>.from(_activeThread!.messages)
      ..add(newMessage);

    final updatedThread = ChatThread(
      id: _activeThread!.id,
      peerName: _activeThread!.peerName,
      initials: _activeThread!.initials,
      lastMessage: text.trim(),
      lastTime: 'Just now',
      unreadCount: 0,
      syncPercentage: 100,
      isOnline: _activeThread!.isOnline,
      isDirect: _activeThread!.isDirect,
      messages: updatedMessages,
    );

    final index = _threads.indexWhere((t) => t.id == _activeThread!.id);
    if (index != -1) {
      _threads[index] = updatedThread;
    }
    _activeThread = updatedThread;
    notifyListeners();
  }
}
