import 'package:client/core/theme/app.theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomBarChart extends StatefulWidget {
  final List<Map<String, int>> data;

  CustomBarChart({super.key, required this.data});

  final Color barBackgroundColor = Colors.white.withOpacity(0.3);
  final Color barColor = AppTheme.titleColor;
  final Color touchedBarColor = AppTheme.textColor;

  @override
  State<StatefulWidget> createState() => CustomBarChartState();
}

class CustomBarChartState extends State<CustomBarChart> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  late final List<String> months;
  late final List<double> eventCounts;

  @override
  void initState() {
    super.initState();
    months = widget.data.map((e) => e.keys.first).toList();
    eventCounts = widget.data.map((e) => e.values.first.toDouble()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      duration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: eventCounts.reduce((a, b) => a > b ? a : b) * 1.1,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(months.length, (i) {
      return makeGroupData(i, eventCounts[i], isTouched: i == touchedIndex);
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${months[group.x]}\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: rod.toY.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    if (value.toInt() >= 0 && value.toInt() < months.length) {
      return SideTitleWidget(
        meta: meta,
        space: 16,
        child: Text(months[value.toInt()], style: style),
      );
    }
    return const SizedBox.shrink();
  }
}
