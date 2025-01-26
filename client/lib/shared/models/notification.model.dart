class NotificationInfo {
  final int id;
  final int userId;
  // final String fcmToken;
  final int assetId;
  final String assetIp;
  final String description;
  final DateTime creationDate;

  NotificationInfo({
    required this.id,
    required this.userId,
    // required this.fcmToken,
    required this.assetId,
    required this.assetIp,
    required this.description,
    required this.creationDate,
  });

  factory NotificationInfo.fromJson(Map<String, dynamic> json){
    return NotificationInfo(
      id: json['id'],
      userId: json['user_id'],
      // fcmToken: json['fcm_token'],
      assetId: json['asset_id'],
      assetIp: json['asset_ip'],
      description: json['description'],
      creationDate: DateTime.parse(json['creation_date']),
    );
  }
}

class NotificationUpdate{
  final int id;
  final int userId;

  NotificationUpdate({
    required this.id,
    required this.userId
  });

}