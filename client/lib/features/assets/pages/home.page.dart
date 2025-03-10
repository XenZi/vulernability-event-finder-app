import 'dart:convert';
import 'dart:math';
import 'package:client/core/network/api.client.dart';
import 'package:client/core/theme/app.theme.dart';
import 'package:client/shared/components/box/box-with-title.widget.dart';
import 'package:client/shared/components/charts/bar-chart.widget.dart';
import 'package:client/shared/components/charts/pie-chart.widget.dart';
import 'package:client/shared/components/scaffolds/global-scaffold.widget.dart';
import 'package:client/shared/models/event.model.dart';
import 'package:client/shared/models/ip-asset-with-event-number.model.dart';
import 'package:client/shared/tables/ip-with-number-of-events.table.dart';
import 'package:client/shared/tables/most-recent-events.table.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, int>? eventPrioritiesData = {};
  Map<String, int>? categories = {};
  List<Map<String, int>>? byMonth = [];
  List<MostRecentEvent> mostRecentEvents = [];
  List<HostEvent> hostEvents = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDashboardEventPrioritiesData();
    fetchDashboardCategoriesData();
    fetchEventsByMonth();
    fetchMostRecentEventsForDashboardTable();
    fetchTopHostsForDashboard();
  }

  Future<void> fetchTopHostsForDashboard() async {
    try {
      final response = await ApiClient().get('/dashboard/top-hosts',
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY4NDUyMzh9.cpUMRBf4XUL-AtFb5dkrJAm9UtoN5seJfxFBoizGhtY");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          hostEvents = data.map((item) => HostEvent.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> fetchMostRecentEventsForDashboardTable() async {
    try {
      final response = await ApiClient().get('/dashboard/recent-updates',
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MjI3MzY4NDUyMzh9.cpUMRBf4XUL-AtFb5dkrJAm9UtoN5seJfxFBoizGhtY");
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          mostRecentEvents = (data['data'] as List)
              .map((item) => MostRecentEvent.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
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
      return GlobalScaffold(
        child: Center(
          child: Text(errorMessage!),
        ),
      );
    }
    return GlobalScaffold(
        child: SingleChildScrollView(
      child: Column(
        children: [
          BoxWithTitle(
            title: "Event Priorities",
            child: PieChartSample(
              data: eventPrioritiesData?.entries
                      .map((entry) => {entry.key: entry.value})
                      .toList() ??
                  [],
              colors: const [Colors.green, Colors.orange, Colors.red],
              showPercentage: true,
            ),
          ),
          MostRecentEventsTable(
            events: mostRecentEvents,
          ),
          const SizedBox(height: 16.0),
          BoxWithTitle(
            title: "Event Categories",
            child: PieChartSample(
              data: categories?.entries
                      .map((entry) => {entry.key: entry.value})
                      .toList() ??
                  [],
              colors: generateRandomColors(categories!.length),
              showPercentage: false,
            ),
          ),
          const SizedBox(height: 16.0),
          IpEventTable(ipEventData: hostEvents),
          BoxWithTitle(
            title: "Monthly Events",
            child: CustomBarChart(
              data: byMonth!,
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    ));
  }
}
