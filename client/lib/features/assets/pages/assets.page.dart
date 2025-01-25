import 'dart:convert';
import 'dart:io';

import 'package:client/core/network/api.client.dart';
import 'package:client/core/security/secure-storage.component.dart';
import 'package:client/core/theme/app.theme.dart';
import 'package:client/features/assets/widgets/asset-cart.widget.dart';
import 'package:client/shared/components/inputs/bottom_input_modal.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/models/assets.model.dart';
import 'package:client/shared/components/scaffolds/global-scaffold.widget.dart';
import 'package:client/shared/utils/validators.dart';
import 'package:flutter/material.dart';

class AssetListPage extends StatefulWidget {
  const AssetListPage({super.key});

  @override
  AssetListPageState createState() => AssetListPageState();
}

class AssetListPageState extends State<AssetListPage> {
  final ApiClient apiClient = ApiClient();
  final ScrollController _scrollController = ScrollController();
  Map<String, String> searchQueryValues = {
    "orderBy": "creation_date",
    "orderByCriteria": "DESC"
  };
  List<Asset> assets = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  bool hasMoreAssets = true;
  int currentPage = 1;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchAssets();
  }

  Future<void> fetchAssets(
      {int page = 1, String orderBy = "", String orderByCriteria = ""}) async {
    if (isFetchingMore) return;
    setState(() {
      if (page == 1) isLoading = true;
      isFetchingMore = true;
    });
    try {
      final response = await apiClient.get(
        '/assets/user_assets/?page=$page&order_by=${searchQueryValues["orderBy"]}&order_by_criteria=${searchQueryValues["orderByCriteria"]}',
        await SecureStorage.loadToken(),
      );

      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          if (page == 1) {
            assets = data.map((json) => Asset.fromJson(json)).toList();
          } else {
            assets.addAll(data.map((json) => Asset.fromJson(json)).toList());
          }
          currentPage = page;
          hasMoreAssets = data.isNotEmpty;
          isLoading = false;
          isFetchingMore = false;
        });
      } else {
        throw Exception('Failed to load assets');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
        isFetchingMore = false;
      });
    }
  }

  Future<void> createAndAppendNewAsset(String input) async {
    try {
      final response = await apiClient.post(
        '/assets/',
        {
          'ip': input,
        },
        await SecureStorage.loadToken(),
      );
      print(response.body);
      final newAsset = Asset.fromJson(json.decode(response.body));
      setState(() {
        assets.insert(0, newAsset);
      });
    } on HttpException catch (e) {
      print("Error $e");
      ToastBar.show(
        context,
        e.message,
        style: ToastBarStyle.error,
      );
    } on Exception catch (e) {
      print(" ERROR $e");
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
              createAndAppendNewAsset(input);
              Navigator.pop(context);
            },
          );
        });
  }

  Future<void> deleteAsset(int assetID, int index) async {
    try {
      final response = await apiClient.delete(
        '/assets/$assetID',
        await SecureStorage.loadToken(),
      );
      print(response.body);
      setState(() {
        assets.removeAt(index);
      });
    } on HttpException catch (e) {
      print("Error $e");
      ToastBar.show(
        context,
        e.message,
        style: ToastBarStyle.error,
      );
    } on Exception catch (e) {
      print(" ERROR $e");
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        hasMoreAssets &&
        !isFetchingMore) {
      fetchAssets(page: currentPage + 1);
    }
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Assets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sort by'),
                items: const [
                  DropdownMenuItem(
                      value: 'creation_date-asc', child: Text('Oldest')),
                  DropdownMenuItem(
                      value: 'creation_date-desc', child: Text('Newest')),
                  DropdownMenuItem(
                      value: 'notification_priority_level-asc',
                      child: Text('Lowest priority')),
                  DropdownMenuItem(
                      value: 'notification_priority_level-desc',
                      child: Text('Highest priority')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    final parts = value.split('-');
                    final order = parts[1].toUpperCase();
                    setState(() {
                      searchQueryValues["orderBy"] = parts[0];
                      searchQueryValues["orderByCriteria"] = order;
                    });
                    fetchAssets();
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    )
                  : assets.isEmpty
                      ? const Center(
                          child: Text(
                            'No assets available!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: assets.length + (hasMoreAssets ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == assets.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final asset = assets[index];
                            return AssetCard(
                              key: ValueKey(asset.id),
                              asset: asset,
                              apiClient: apiClient,
                              onDelete: () => {deleteAsset(asset.id, index)},
                            );
                          },
                        ),
          // Floating Buttons
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'filter_button',
                  onPressed: () => _showFilterModal(context),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.filter_list),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'add_button',
                  onPressed: () => _showInputModal(context),
                  backgroundColor: AppTheme.titleColor,
                  child: const Icon(
                    Icons.add,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
