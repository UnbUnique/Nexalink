enum NodeType {
  teacher,
  student,
  relay,
}

enum ConnectionProtocol {
  wifiDirect,
  bluetoothLe,
}

class MeshNode {
  final String id;
  final String name;
  final NodeType type;
  final ConnectionProtocol protocol;
  final int hops;
  final int rssiDbm;
  final int batteryPercent;
  final bool isOnline;
  final double radarAngle; // In radians or degrees
  final double radarDistance; // 0.0 (center) to 1.0 (edge)

  const MeshNode({
    required this.id,
    required this.name,
    required this.type,
    required this.protocol,
    required this.hops,
    required this.rssiDbm,
    required this.batteryPercent,
    this.isOnline = true,
    required this.radarAngle,
    required this.radarDistance,
  });

  String get typeLabel {
    switch (type) {
      case NodeType.teacher:
        return 'Teacher';
      case NodeType.student:
        return 'Student';
      case NodeType.relay:
        return 'Relay';
    }
  }

  String get protocolLabel {
    switch (protocol) {
      case ConnectionProtocol.wifiDirect:
        return 'Wi-Fi Direct';
      case ConnectionProtocol.bluetoothLe:
        return 'Bluetooth LE';
    }
  }
}
