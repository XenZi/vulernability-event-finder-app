import 'package:client/shared/models/priority.enum.dart';

class Event {
  final int id;
  final String uuid;
  final String status;
  final String host;
  final String port;
  final PriorityLevel priority;
  final String categoryName;
  final DateTime creationDate;
  final DateTime lastOccurrence;
  final int assetId;

  Event({
    required this.id,
    required this.uuid,
    required this.status,
    required this.host,
    required this.port,
    required this.priority,
    required this.categoryName,
    required this.creationDate,
    required this.lastOccurrence,
    required this.assetId,
  });



  factory Event.fromJson(Map<String, dynamic> json) {
    Map<int, String> eventStatuses = {
      0: 'Discovered',
      1: 'Acknowledged',
      2: 'Removed',
      3: 'False Positive',
    };
    return Event(
      id: json['id'],
      uuid: json['uuid'],
      status: eventStatuses[json['status']]!,
      host: json['host'],
      port: json['port'],
      priority: PriorityLevel.values[json['priority']],
      categoryName: json['category_name'],
      creationDate: DateTime.parse(json['creation_date']),
      lastOccurrence: DateTime.parse(json['last_occurrence']),
      assetId: json['asset_id'],
    );
  }
}

class MostRecentEvent {
  final int id;
  final PriorityLevel priority;
  final String categoryName;

  MostRecentEvent({
    required this.id,
    required this.priority,
    required this.categoryName,
  });

  factory MostRecentEvent.fromJson(Map<String, dynamic> json) {
    return MostRecentEvent(
      id: json['event_id'],
      priority: PriorityLevel.values[json['priority']],
      categoryName: json['category_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'priority': priority.index,
      'category_name': categoryName,
    };
  }
}

class EventInfo {
  final String uuid;
  final String category;
  final String description;

  

  
  EventInfo({
    required this.uuid,
    required this.category,
    required this.description,


  });



  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
      uuid: json['uuid'],
      category: json['category'],
      description: json['description'],
    );
  }
}
