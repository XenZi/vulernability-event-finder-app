import 'package:client/core/network/api.client.dart';
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
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3Mzc2NDk4Njh9.syHu6AlmV1zGvWCh847AvBLXEITTXt_pOxnksNie8A0");
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
                          Text(
                            notification.description,
                            style: const TextStyle(color: AppTheme.textColor),

                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
