import 'dart:io';

import 'package:client/core/network/api.client.dart';
import 'package:client/core/security/secure-storage.component.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:client/features/assets/widgets/asset-cart.widget.dart';
import 'package:client/shared/components/inputs/bottom_input_modal.dart';
import 'package:client/shared/components/toast/toast.widget.dart';
import 'package:client/shared/models/assets.model.dart';
import 'package:client/shared/components/scaffolds/global-scaffold.widget.dart';
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
  final ScrollController _scrollController = ScrollController();
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

  Future<void> fetchAssets({int page = 1}) async {
    if (isFetchingMore) return;

    setState(() {
      if (page == 1) isLoading = true;
      isFetchingMore = true;
    });
    print("/assets/user_assets/?page=$page");
    try {
      final response = await apiClient.get(
        '/assets/user_assets/?page=$page',
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY2NzMzMTl9.EinBgCnUl9s7ZRrTsRojr7CCbe1eJZJDdfGTacHEtbs",
      );

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
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(
                      value: 'category1', child: Text('Category 1')),
                  DropdownMenuItem(
                      value: 'category2', child: Text('Category 2')),
                ],
                onChanged: (value) {
                  // Handle filter logic
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Apply filter logic
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
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
