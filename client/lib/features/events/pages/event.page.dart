import 'dart:convert';

import 'package:client/core/network/api.client.dart';
import 'package:client/core/theme/app.theme.dart';
import 'package:client/shared/components/box/box-with-title.widget.dart';
import 'package:client/shared/components/buttons/button.widget.dart';
import 'package:client/shared/components/scaffolds/global-scaffold.widget.dart';
import 'package:client/shared/models/event.model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, this.goRouterState});
  final GoRouterState? goRouterState;


  @override
  EventPageState createState() => EventPageState();

}

class EventPageState extends State<EventPage> {
  final ApiClient apiClient = ApiClient();
  late int assetId;
  late EventInfo event;
  

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState(){
    super.initState();
    fetchEvent();
  }


  void _goBack(){
    context.go("/events/$assetId");
  }


  Future<void> fetchEvent() async {
    assetId = int.parse(widget.goRouterState!.pathParameters['assetId'] as String);
    final eventUUID = widget.goRouterState?.pathParameters['uuid'];

    if (eventUUID == null) {
      setState(() {
        errorMessage = 'Event UUID is missing from the URL';
        isLoading = false;
      });
      return;
    }
    try {
      final response = await apiClient.get('/events/uuid/$eventUUID',
       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY2NzMzMTl9.EinBgCnUl9s7ZRrTsRojr7CCbe1eJZJDdfGTacHEtbs");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          event = EventInfo.fromJson(data);
          isLoading = false;
        });
       } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        print(errorMessage);
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: GlobalScaffold(
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.titleColor,
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return GlobalScaffold(
        child: Center(
          child: Text(errorMessage!),
        ),
      );
    } 

return GlobalScaffold(
  child: SingleChildScrollView(
    child: Column(
      children: [
        BoxWithTitle(
          title: "Event UUID:",
          child: Text(event.uuid),
        ),
        BoxWithTitle(
          title: "Event Category",
          child: Text(event.category),
        ),
        BoxWithTitle(
          title: "Event Description",
          child: Text(event.description),
        ),CustomButton(label: "Back", onPressed:() => _goBack() )
          ],
        ),
      ),
    );
      
  }
}


