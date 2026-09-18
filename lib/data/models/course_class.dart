class CourseClass {
  final String id;
  final String code;
  final String name;
  final String professor;
  final String location;
  final int peerCount;
  final int syncPercentage;
  final bool isCurrentActive;
  final String syncStatusText;
  final String? nextLabTitle;
  final String? nextLabTime;
  final String? readingTitle;
  final String? readingTime;

  const CourseClass({
    required this.id,
    required this.code,
    required this.name,
    required this.professor,
    required this.location,
    required this.peerCount,
    required this.syncPercentage,
    required this.isCurrentActive,
    required this.syncStatusText,
    this.nextLabTitle,
    this.nextLabTime,
    this.readingTitle,
    this.readingTime,
  });

  CourseClass copyWith({
    bool? isCurrentActive,
    int? syncPercentage,
    String? syncStatusText,
    int? peerCount,
  }) {
    return CourseClass(
      id: id,
      code: code,
      name: name,
      professor: professor,
      location: location,
      peerCount: peerCount ?? this.peerCount,
      syncPercentage: syncPercentage ?? this.syncPercentage,
      isCurrentActive: isCurrentActive ?? this.isCurrentActive,
      syncStatusText: syncStatusText ?? this.syncStatusText,
      nextLabTitle: nextLabTitle,
      nextLabTime: nextLabTime,
      readingTitle: readingTitle,
      readingTime: readingTime,
    );
  }
}
