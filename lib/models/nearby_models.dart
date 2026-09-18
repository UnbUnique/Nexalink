/// Connection state enum for peer devices.
enum ConnectionState {
  connecting,
  connected,
  disconnected,
  rejected,
  unknown;

  static ConnectionState fromString(String? state) {
    switch (state?.toUpperCase()) {
      case 'CONNECTING':
        return ConnectionState.connecting;
      case 'CONNECTED':
        return ConnectionState.connected;
      case 'DISCONNECTED':
        return ConnectionState.disconnected;
      case 'REJECTED':
        return ConnectionState.rejected;
      default:
        return ConnectionState.unknown;
    }
  }
}

/// Discovered peer device in proximity.
class DiscoveredDevice {
  final String endpointId;
  final String endpointName;

  const DiscoveredDevice({
    required this.endpointId,
    required this.endpointName,
  });

  factory DiscoveredDevice.fromMap(Map<dynamic, dynamic> map) {
    return DiscoveredDevice(
      endpointId: map['endpointId'] as String? ?? '',
      endpointName: map['endpointName'] as String? ?? 'Unknown',
    );
  }
}

/// Peer device with connection state.
class PeerDevice {
  final String endpointId;
  final String endpointName;
  final ConnectionState state;

  const PeerDevice({
    required this.endpointId,
    required this.endpointName,
    required this.state,
  });

  factory PeerDevice.fromMap(Map<dynamic, dynamic> map) {
    return PeerDevice(
      endpointId: map['endpointId'] as String? ?? '',
      endpointName: map['endpointName'] as String? ?? 'Unknown',
      state: ConnectionState.fromString(map['state'] as String?),
    );
  }
}

/// Offline chat message model.
class ChatMessage {
  final String id;
  final String senderEndpointId;
  final String senderName;
  final String text;
  final int timestamp;
  final bool isIncoming;

  const ChatMessage({
    required this.id,
    required this.senderEndpointId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isIncoming,
  });

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String? ?? '',
      senderEndpointId: map['senderEndpointId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? 'Unknown',
      text: map['text'] as String? ?? '',
      timestamp: map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      isIncoming: map['isIncoming'] as bool? ?? true,
    );
  }
}
