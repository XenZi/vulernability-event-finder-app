import 'package:client/core/network/api.client.dart';
import 'package:client/core/security/secure-storage.component.dart';
import 'package:client/core/theme/app.theme.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/models/notification.model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationCard extends StatelessWidget {
  final NotificationInfo notification;
  final ApiClient apiClient;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.apiClient,
  });

  Future<void> _markAsSeen(BuildContext context) async {
    try{
      await apiClient.put(
        '/notifications/user_notifications/single/', 
        {
          "id":notification.id,
          "user_id":notification.userId
        },
        await SecureStorage.loadToken(),);
      if (context.mounted) {
        context.push("/events/${notification.assetId}");
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
    return GestureDetector(
        onTap: () => _markAsSeen(context),
        child: Card(
          color: AppTheme.backgroundColor.withOpacity(0.9),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.assetIp,
                          style: const TextStyle(color: AppTheme.textColor)),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${notification.creationDate.toLocal().toString().split(" ")[0]}',
                        style: const TextStyle(color: AppTheme.textColor),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${notification.assetIp} has ${notification.eventCount} discovered events",
                              style: const TextStyle(color: AppTheme.textColor),
                              softWrap: true,
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
