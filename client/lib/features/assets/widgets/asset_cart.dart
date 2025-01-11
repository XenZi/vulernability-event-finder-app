import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/circle_icon.dart';
import 'package:client/shared/models/assets.dart';
import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  static const Map<String, Color> priorityColors = {
    "High": Colors.red,
    "Medium": Colors.orange,
    "Low": Colors.green,
    "No Priority": Colors.grey,
  };

  const AssetCard({
    Key? key,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(asset.creationDate);
    return Card(
      color: AppTheme.backgroundColor.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: AppTheme.titleColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.storage,
            color: AppTheme.titleColor,
          ),
        ),
        title: Text(
          asset.ip,
          style: TextStyle(
              color: AppTheme.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created: ${asset.creationDate.toLocal().toString().split(" ")[0]}',
              style: TextStyle(color: AppTheme.textColor),
            ),
            Row(
              children: [
                Text(
                  'Notification Type: ',
                  style: TextStyle(color: AppTheme.textColor, fontSize: 12),
                ),
                Text(
                  asset.notificationPriorityLevel,
                  style: TextStyle(
                      color: priorityColors[asset.notificationPriorityLevel] ??
                          Colors.grey,
                      fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Wrap(
          spacing: 3,
          children: [
            CircleIconButton(
              icon: Icons.edit,
              color: Colors.orange,
              size: 16,
              onPressed: () => {
                print("Edit Asset ID: ${asset.id}"),
              },
            ),
            CircleIconButton(
              icon: Icons.delete,
              color: Colors.red,
              size: 20,
              onPressed: () => {
                print("Delete Asset ID: ${asset.id}"),
              },
            ),
          ],
        ),
      ),
    );
  }
}
