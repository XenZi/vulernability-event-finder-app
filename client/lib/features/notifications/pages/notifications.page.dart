import 'dart:convert';

import 'package:client/core/network/api.client.dart';
import 'package:client/core/security/secure-storage.component.dart';
import 'package:client/features/notifications/widgets/notification-card.widget.dart';
import 'package:client/shared/components/scaffolds/global-scaffold.widget.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/models/notification.model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key, this.goRouterState});
  final GoRouterState? goRouterState;

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationListPage> {
  final ApiClient apiClient = ApiClient();
  List<NotificationInfo> notifications = [];
  bool isLoading = true;
  String? errorMessage;
  


  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }


  Future<void> fetchNotifications() async {
      print("request sending");
    try{
      print("request sent");
      final response = await apiClient.get('/notifications/user_notifications/',
          await SecureStorage.loadToken());
      print("request response received");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          notifications = data.map((json) => NotificationInfo.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        print(errorMessage);
        print("Failed to catch something");
        isLoading = false;
      });
    }
  }

    Future<void> _markAllSeen(BuildContext context) async {
    try{
      await apiClient.put(
        '/notifications/user_notifications/all/', 
        {},
        await SecureStorage.loadToken(),);
      if (context.mounted) {
        context.push("/");
      }
      } catch (e) {
      if (context.mounted) {
        ToastBar.show(
          context,
          e.toString(),
          style: ToastBarStyle.error,
        );
      }
    }
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
              : notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'No events available!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationCard(
                          key: ValueKey(notification.id),
                          notification: notification,
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
                  heroTag: 'filter_button',
                  onPressed: () => _markAllSeen(context),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.mark_chat_read_outlined),
                ),
                const SizedBox(height: 16),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
