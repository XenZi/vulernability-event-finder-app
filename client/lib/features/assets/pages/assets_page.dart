import 'package:client/core/network/api_client.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:client/features/assets/widgets/asset_cart.dart';
import 'package:client/shared/components/bottom_input_modal.dart';
import 'package:client/shared/models/assets.dart';
import 'package:client/shared/components/global_scaffold.dart';
import 'package:client/shared/utils/validators.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AssetListPage extends StatefulWidget {
  const AssetListPage({super.key});

  @override
  AssetListPageState createState() => AssetListPageState();
}

class AssetListPageState extends State<AssetListPage> {
  final ApiClient apiClient = ApiClient();
  List<Asset> assets = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAssets();
  }

  Future<void> fetchAssets() async {
    try {
      final response = await apiClient.get('/assets/user_assets/',
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY2NzMzMTl9.EinBgCnUl9s7ZRrTsRojr7CCbe1eJZJDdfGTacHEtbs");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          assets = data.map((json) => Asset.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load assets');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  void _showInputModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return BottomInputModal(
            title: 'Enter Asset Address',
            textController: TextEditingController(),
            hintText: 'Type something...',
            validators: [validateRequiredField, validateIPAddress],
            onSubmit: (input) {
              if (input.isNotEmpty) {
                print('User Input: $input');
                Navigator.pop(context);
              } else {
                print('Input is required.');
              }
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputModal(context),
        backgroundColor: AppTheme.titleColor,
        child: const Icon(
          Icons.add,
          color: AppTheme.textColor,
        ),
      ),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : assets.isEmpty
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
                          key: ValueKey(asset.id),
                          asset: asset,
                          apiClient: apiClient,
                        );
                      },
                    ),
    );
  }
}
