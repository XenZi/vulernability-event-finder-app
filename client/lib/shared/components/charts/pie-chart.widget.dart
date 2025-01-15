import 'package:client/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartSample extends StatefulWidget {
  final List<Map<String, int>> data;
  final List<Color> colors;
  final bool showPercentage;
  PieChartSample(
      {required this.data, required this.colors, required this.showPercentage});

  @override
  PieChartSampleState createState() => PieChartSampleState();
}

class PieChartSampleState extends State<PieChartSample> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total =
        widget.data.fold<int>(0, (sum, element) => sum + element.values.first);

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: _showingSections(total),
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12.0,
            runSpacing: 16.0,
            children: widget.data.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value.keys.first;
              return Indicator(
                color: widget.colors[index],
                text: label,
              );
            }).toList(),
          )
        ]);
  }

  List<PieChartSectionData> _showingSections(int total) {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value.values.first;
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 60 : 50;
      final fontSize = isTouched ? 25.0 : 16.0;

      return PieChartSectionData(
        color: widget.colors[index],
        value: value.toDouble(),
        title:
            '${widget.showPercentage ? '${(value / total * 100).toStringAsFixed(1)}%' : value}',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      );
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        SizedBox(height: 4), // Adds space between the container and the text
        Text(
          text[0].toUpperCase() + text.substring(1),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }
}
