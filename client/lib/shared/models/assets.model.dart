class Asset {
  final int id;
  final String ip;
  final String notificationPriorityLevel;
  final DateTime creationDate;
  final int userId;

  Asset({
    required this.id,
    required this.ip,
    required this.notificationPriorityLevel,
    required this.creationDate,
    required this.userId,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    Map<int, String> priorityLevels = {
      3: 'High',
      2: 'Medium',
      1: 'Low',
      0: 'Unset priority',
    };
    return Asset(
      id: json['id'],
      ip: json['ip'],
      notificationPriorityLevel:
          priorityLevels[json['notification_priority_level']]!,
      creationDate: DateTime.parse(json['creation_date']),
      userId: json['user_id'],
    );
  }
}

class AssetForUpdate {
  final int id;
  final String ip;
  final int notificationPriorityLevel;
  final DateTime creationDate;
  final int userId;

  AssetForUpdate({
    required this.id,
    required this.ip,
    required this.notificationPriorityLevel,
    required this.creationDate,
    required this.userId,
  });
}
