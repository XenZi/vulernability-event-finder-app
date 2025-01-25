import 'package:client/core/theme/app.theme.dart';
import 'package:client/shared/components/navbars/bottom-navigation.widget.dart';
import 'package:client/shared/components/navbars/top-navigation-bar.widget.dart';
import 'package:flutter/material.dart';

class NotificationListPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'System Update',
      'body': 'Your system update is ready to install.',
      'timestamp': '10:00 AM'
    },
    {
      'title': 'Welcome!',
      'body': 'Thanks for joining our app.',
      'timestamp': 'Yesterday'
    },
    {
      'title': 'New Feature',
      'body': 'Check out the latest feature in our app.',
      'timestamp': '2 days ago'
    },
  ];

  NotificationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: TopNavigationBar(),
      body: notifications.isEmpty
          ? Center(
              child: Text('No notifications yet!',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  color: AppTheme.darkerBackgroundColor,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading:
                        Icon(Icons.notifications, color: AppTheme.titleColor),
                    title: Text(notification['title'] ?? '',
                        style: TextStyle(color: AppTheme.titleColor)),
                    subtitle: Text(
                      notification['body'] ?? '',
                      style: TextStyle(color: AppTheme.textColor),
                    ),
                    trailing: Text(notification['timestamp'] ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                );
              },
            ),
      bottomNavigationBar: NavigationComponent(),
    );
  }
}
