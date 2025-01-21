class HostEvent {
  final int id;
  final String host;
  final int eventCount;

  HostEvent({
    required this.id,
    required this.host,
    required this.eventCount,
  });

  // Factory constructor to create an instance from a JSON map
  factory HostEvent.fromJson(Map<String, dynamic> json) {
    return HostEvent(
      id: json['id'] as int,
      host: json['host'] as String,
      eventCount: json['event_count'] as int,
    );
  }

  // Method to convert an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host': host,
      'event_count': eventCount,
    };
  }

  @override
  String toString() {
    return 'HostEvent(id: $id, host: $host, eventCount: $eventCount)';
  }
}

// Function to parse a list of HostEvent from JSON
List<HostEvent> parseHostEvents(List<dynamic> jsonList) {
  return jsonList.map((json) => HostEvent.fromJson(json)).toList();
}
