import 'package:client/core/network/api.client.dart';
import 'package:client/core/theme/app.theme.dart';
import 'package:client/shared/components/icons/circle-icon.widget.dart';
import 'package:client/shared/components/selections/bottom-selection-menu.widget.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/models/event-status.enum.dart';
import 'package:client/shared/models/event.model.dart';
import 'package:client/shared/models/menu-option.model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final ApiClient apiClient;

  const EventCard({
    super.key,
    required this.event,
    required this.apiClient,
  });

  List<MenuOption> _getMenuItems(BuildContext context) => EventStatus.values
      .map(
        (eventStatus) => MenuOption(
          text: eventStatus.label,
          icon: Icons.privacy_tip,
          iconColor: eventStatus.color,
          onTap: () => _changeEventStatus(context, eventStatus),
        ),
      )
      .toList();



  Future<void> _changeEventStatus(
      BuildContext context, EventStatus eventStatus) async {
    try {
      print(eventStatus.index);
      await apiClient.put(
          "/events/update",
          {
            "id": event.id,
            "status": eventStatus.index,
            "asset_id": event.assetId,
          },
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3Mzc2NDk4Njh9.syHu6AlmV1zGvWCh847AvBLXEITTXt_pOxnksNie8A0");
      if (context.mounted) {
        ToastBar.show(
          context,
          "Status updated successfully.",
          style: ToastBarStyle.success,
        );
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

  void _showEventStatusSelection(BuildContext context) {
    DynamicSelectionMenu.show(
      context: context,
      options: _getMenuItems(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {context.push("/event/${event.assetId}/${event.uuid}")},
        child: Card(
          color: AppTheme.backgroundColor.withOpacity(0.9),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleIconButton(
                  icon: Icons.storage,
                  color: AppTheme.titleColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.uuid,
                          style: const TextStyle(color: AppTheme.textColor)),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${event.creationDate.toLocal().toString().split(" ")[0]}',
                        style: const TextStyle(color: AppTheme.textColor),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Status: ',
                              style: TextStyle(color: AppTheme.textColor)),
                          Text(
                            event.status,
                            style: TextStyle(
                              color: EventStatus.values
                                  .firstWhere(
                                    (p) => p.label == event.status,
                                    orElse: () => EventStatus.discovered,
                                  )
                                  .color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    CircleIconButton(
                      icon: Icons.edit,
                      color: Colors.orange,
                      size: 20,
                      onPressed: () => _showEventStatusSelection(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
