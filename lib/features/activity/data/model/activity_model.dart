enum ActivityType {
  irrigation,
  fertilizing,
  spraying,
  other;

  // shortcut: type enum is TBD (spec T4); unknown -> other.
  static ActivityType parse(String? value) =>
      ActivityType.values.firstWhere(
        (type) => type.name == value,
        orElse: () => ActivityType.other,
      );
}

class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.scheduledAt,
    required this.isDone,
    this.description,
  });

  factory ActivityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ActivityModel(
      id: json['id'] as int,
      type: ActivityType.parse(json['type'] as String?),
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledAt: DateTime.parse(
        json['scheduled_at'] as String,
      ),
      // shortcut: any status other than 'done' is pending; no
      // overdue state in the design.
      isDone: json['status'] == 'done',
    );
  }

  final int id;
  final ActivityType type;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final bool isDone;
}
