enum SectorSeverity {
  critical,
  shelter,
  monitoring,
}

class AffectedSector {
  final String id;
  final String name;
  final String instruction;
  final SectorSeverity severity;

  const AffectedSector({
    required this.id,
    required this.name,
    required this.instruction,
    required this.severity,
  });

  String get severityLabel {
    switch (severity) {
      case SectorSeverity.critical:
        return 'CRITICAL';
      case SectorSeverity.shelter:
        return 'SHELTER';
      case SectorSeverity.monitoring:
        return 'MONITORING';
    }
  }
}

class UrgentAlertModel {
  final String id;
  final String broadcastNumber;
  final String title;
  final String description;
  final String timeAgo;
  final String source;
  final int nodesSynced;
  final List<AffectedSector> sectors;
  final bool isAcknowledged;

  const UrgentAlertModel({
    required this.id,
    required this.broadcastNumber,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.source,
    required this.nodesSynced,
    required this.sectors,
    this.isAcknowledged = false,
  });

  UrgentAlertModel copyWith({bool? isAcknowledged}) {
    return UrgentAlertModel(
      id: id,
      broadcastNumber: broadcastNumber,
      title: title,
      description: description,
      timeAgo: timeAgo,
      source: source,
      nodesSynced: nodesSynced,
      sectors: sectors,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }
}
