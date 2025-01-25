import 'package:client/core/network/api.client.dart';
import 'package:client/shared/components/selections/bottom-selection-menu.widget.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/models/menu-option.model.dart';
import 'package:client/shared/models/priority.enum.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme/app.theme.dart';
import 'package:client/shared/components/icons/circle-icon.widget.dart';
import 'package:client/shared/models/assets.model.dart';
import 'package:go_router/go_router.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  final ApiClient apiClient;
  final VoidCallback onDelete;
  const AssetCard(
      {super.key,
      required this.asset,
      required this.apiClient,
      required this.onDelete});

  List<MenuOption> _getMenuItems(BuildContext context) => PriorityLevel.values
      .map(
        (priority) => MenuOption(
          text: priority.label,
          icon: Icons.priority_high,
          iconColor: priority.color,
          onTap: () => _changePriorityOfAnAsset(context, priority),
        ),
      )
      .toList();

  Future<void> _changePriorityOfAnAsset(
      BuildContext context, PriorityLevel priority) async {
    try {
      await apiClient.put(
          "/assets/update",
          {
            "id": asset.id,
            "ip": asset.ip,
            "notification_priority_level": priority.index,
            "user_id": asset.userId,
          },
          "dadada");
      if (context.mounted) {
        ToastBar.show(
          context,
          "Priority updated successfully.",
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

  void _showPrioritySelection(BuildContext context) {
    DynamicSelectionMenu.show(
      context: context,
      options: _getMenuItems(context),
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor,
        title: const Text(
          'Confirm Deletion',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textColor),
        ),
        content: const Text(
          'Are you sure you want to delete this asset?',
          style: TextStyle(color: AppTheme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {context.go("/events/${asset.id}")},
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
                      Text(asset.ip,
                          style: const TextStyle(color: AppTheme.textColor)),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${asset.creationDate.toLocal().toString().split(" ")[0]}',
                        style: const TextStyle(color: AppTheme.textColor),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Priority: ',
                              style: TextStyle(color: AppTheme.textColor)),
                          Text(
                            asset.notificationPriorityLevel,
                            style: TextStyle(
                              color: PriorityLevel.values
                                  .firstWhere(
                                    (p) =>
                                        p.label ==
                                        asset.notificationPriorityLevel,
                                    orElse: () => PriorityLevel.none,
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
                      onPressed: () => _showPrioritySelection(context),
                    ),
                    CircleIconButton(
                      icon: Icons.delete,
                      color: Colors.red,
                      size: 20,
                      onPressed: () => _confirmDeletion(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
