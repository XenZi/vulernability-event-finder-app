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
}
