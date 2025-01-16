import 'dart:convert';
import 'dart:math';
import 'package:client/core/network/api_client.dart';
import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/components/box/info_box.dart';
import 'package:client/shared/components/charts/bar-chart.widget.dart';
import 'package:client/shared/components/charts/pie-chart.widget.dart';
import 'package:client/shared/components/global_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, int>? eventPrioritiesData = {};
  Map<String, int>? categories = {};
  List<Map<String, int>>? byMonth = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDashboardEventPrioritiesData();
    fetchDashboardCategoriesData();
    fetchEventsByMonth();
  }

  Future<void> fetchDashboardEventPrioritiesData() async {
    try {
      final response = await ApiClient().get('/dashboard/priorities',
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY4NDUyMzh9.cpUMRBf4XUL-AtFb5dkrJAm9UtoN5seJfxFBoizGhtY");
      if (response.statusCode == 200) {
        setState(() {
          eventPrioritiesData =
              Map<String, int>.from(json.decode(response.body));
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> fetchDashboardCategoriesData() async {
    try {
      final response = await ApiClient().get('/dashboard/categories',
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY4NDUyMzh9.cpUMRBf4XUL-AtFb5dkrJAm9UtoN5seJfxFBoizGhtY");
      setState(() {
        categories = Map<String, int>.from(json.decode(response.body));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> fetchEventsByMonth() async {
    try {
      final response = await ApiClient().get(
        '/dashboard/by-month',
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY4NDUyMzh9.cpUMRBf4XUL-AtFb5dkrJAm9UtoN5seJfxFBoizGhtY",
      );

      print("API Response: ${response.body}");

      final rawData = json.decode(response.body) as List<dynamic>;

      final transformedData = rawData.map((item) {
        final map = item as Map<String, dynamic>;
        return map.map((key, value) => MapEntry(key, value as int));
      }).toList();

      setState(() {
        byMonth = transformedData;
        isLoading = false;
      });
    } catch (e) {
      print("Error in fetchEventsByMonth: $e");
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  List<Color> generateRandomColors(int count) {
    final Random random = Random();
    final Set<Color> uniqueColors = {};

    while (uniqueColors.length < count) {
      final color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );

      uniqueColors.add(color);
    }

    return uniqueColors.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: GlobalScaffold(
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.titleColor,
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!),
      );
    }

    return GlobalScaffold(
        child: Column(
      children: [
        FlutterCarousel(
          items: [
            PieChartSample(
              chartTitle: "Event Priorities",
              data: eventPrioritiesData?.entries
                      .map((entry) => {entry.key: entry.value})
                      .toList() ??
                  [],
              colors: const [Colors.green, Colors.orange, Colors.red],
              showPercentage: true,
            ),
            PieChartSample(
                chartTitle: "Event Categories",
                data: categories?.entries
                        .map((entry) => {entry.key: entry.value})
                        .toList() ??
                    [],
                colors: generateRandomColors(categories!.length),
                showPercentage: false),
            CustomBarChart(
              title: "Events by Month",
              data: byMonth!,
            )
          ],
          options: FlutterCarouselOptions(
              height: MediaQuery.of(context).size.height / 2,
              autoPlay: false,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              showIndicator: false),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            InfoBox(
              title: "Assets",
              icon: Icons.pie_chart_outline,
              text: "You have 12 assets",
            ),
            InfoBox(
              title: "Events",
              icon: Icons.event_note,
              text: "You have 5 events",
            ),
          ],
        )
      ],
    ));
  }
}
