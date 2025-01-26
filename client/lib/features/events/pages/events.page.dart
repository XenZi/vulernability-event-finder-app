import 'dart:convert';

import 'package:client/core/network/api.client.dart';
import 'package:client/core/security/secure-storage.component.dart';
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
  Map<String, String> filterSort = {
    "sort_by": "creation_date",
    "order": "DESC",
    "type": "sort",
    "path": "",
    "filter_value": "example"
  };

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final assetId = widget.goRouterState?.pathParameters['id'];
    if (filterSort['type'] == "sort"){
      setState(() {
      filterSort['path'] = '/events/asset_id/sorted/$assetId/${filterSort['sort_by']}/${filterSort['order']}/';
      });
    } else {
      setState(() {
      filterSort['path'] = '/events/assets_id/filtered/$assetId/${filterSort['filter_value']}/';
      });
    }

    if (assetId == null) {
      setState(() {
        errorMessage = 'Asset ID is missing from the URL';
        isLoading = false;
      });
      return;
    }
    try {
      final response = await apiClient.get(filterSort['path']!,
      await SecureStorage.loadToken(),);
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


  
  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sort Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sort by'),
                items: const [
                  DropdownMenuItem(
                      value: 'status|ASC', child: Text('Status Ascending')),
                  DropdownMenuItem(
                      value: 'status|DESC', child: Text('Status Descending')),
                  DropdownMenuItem(
                      value: 'creation_date|ASC',
                      child: Text('Oldest')),
                  DropdownMenuItem(
                      value: 'creation_date|DESC',
                      child: Text('Newest')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    final parts = value.split('|');
                    setState(() {
                      filterSort["type"] = "sort";
                      filterSort["sort_by"] = parts[0];
                      filterSort["order"] = parts[1];
                    });
                    fetchEvents();
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Filter by'),
                items: const [
                  DropdownMenuItem(
                      value: 'Discovered', child: Text('Discovered')),
                  DropdownMenuItem(
                      value: 'Acknowledged', child: Text('Acknowledged')),
                  DropdownMenuItem(
                      value: 'Removed',
                      child: Text('Removed')),
                  DropdownMenuItem(
                      value: 'FalsePositive',
                      child: Text('False Positive')),
                  
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      filterSort["type"] = "filter";
                      filterSort["filter_value"] = value;
                    });
                    fetchEvents();
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      child: Stack(
        children: [
          isLoading
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
    Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'sort_button',
                  onPressed: () => _showSortModal(context),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.sort_rounded),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'filter_button',
                  onPressed: () => _showFilterModal(context),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.filter_list),
                ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
