import 'dart:convert';
import 'package:client/core/network/api.client.dart';
import 'package:client/features/events/widgets/event-cart.widgets.dart';
import 'package:client/shared/components/scaffolds/global-scaffold.widget.dart';
import 'package:client/shared/models/event.model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key, this.goRouterState});
  final GoRouterState? goRouterState;

  @override
  EventListPageState createState() => EventListPageState();
}

class EventListPageState extends State<EventListPage> {
  final ApiClient apiClient = ApiClient();
  List<Event> events = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final assetId = widget.goRouterState?.pathParameters['id'];

    if (assetId == null) {
      setState(() {
        errorMessage = 'Asset ID is missing from the URL';
        isLoading = false;
      });
      return;
    }
    try {
      final response = await apiClient.get('/events/asset_id/$assetId',
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY2NzMzMTl9.EinBgCnUl9s7ZRrTsRojr7CCbe1eJZJDdfGTacHEtbs");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((json) => Event.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        print("Failed to catch something");
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : events.isEmpty
                  ? const Center(
                      child: Text(
                        'No events available!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return EventCard(
                          key: ValueKey(event.id),
                          event: event,
                          apiClient: apiClient,
                        );
                      },
                    ),
    );
  }
}
