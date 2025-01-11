import 'package:client/features/assets/widgets/asset_cart.dart';
import 'package:client/shared/models/assets.dart';
import 'package:flutter/material.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/navigation_component.dart';
import 'package:client/shared/components/top_navigation_bar.dart';

class AssetListPage extends StatelessWidget {
  final List<Asset> assets = List.generate(
    10,
    (index) => Asset(
      id: index + 1,
      ip: "192.168.1.${index + 1}",
      notificationPriorityLevel: index % 2 == 0 ? "Low" : "High",
      creationDate: DateTime.now().subtract(Duration(days: index)),
      userId: 1000 + index,
    ),
  );

  AssetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: TopNavigationBar(),
      body: assets.isEmpty
          ? Center(
              child: Text(
                'No assets available!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return AssetCard(
                  asset: asset,
                );
              },
            ),
      bottomNavigationBar: const NavigationComponent(),
    );
  }
}
