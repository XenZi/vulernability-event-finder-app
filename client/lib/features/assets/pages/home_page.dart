import 'dart:convert';
import 'dart:math';
import 'package:client/core/network/api_client.dart';
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

      // Transform to a List<Map<String, int>> by explicitly casting
      final transformedData = rawData.map((item) {
        final map = item as Map<String, dynamic>; // Decode each item
        return map.map(
            (key, value) => MapEntry(key, value as int)); // Cast values to int
      }).toList();

      setState(() {
        byMonth = transformedData;
        print("$byMonth DJAJDAJSDASDASDAS");
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

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
        child: Column(
      children: [
        FlutterCarousel(
          items: [
            PieChartSample(
              data: eventPrioritiesData?.entries
                      .map((entry) => {entry.key: entry.value})
                      .toList() ??
                  [],
              colors: [Colors.green, Colors.orange, Colors.red],
              showPercentage: true,
            ),
            PieChartSample(
                data: categories?.entries
                        .map((entry) => {entry.key: entry.value})
                        .toList() ??
                    [],
                colors: generateRandomColors(categories!.length),
                showPercentage: false),
            BarChartSample1(
              data: byMonth!,
            )
          ],
          options: FlutterCarouselOptions(
              height: MediaQuery.of(context).size.height / 2,
              autoPlay: false,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              showIndicator: false),
        )
      ],
    ));
  }

  List<Color> generateRandomColors(int count) {
    final Random random = Random();
    final Set<Color> uniqueColors = {};

    while (uniqueColors.length < count) {
      // Generate random RGB values
      final color = Color.fromARGB(
        255, // Full opacity
        random.nextInt(256), // Red
        random.nextInt(256), // Green
        random.nextInt(256), // Blue
      );

      uniqueColors.add(color); // Ensure uniqueness by using a Set
    }

    return uniqueColors.toList(); // Convert the Set to a List
  }
}
