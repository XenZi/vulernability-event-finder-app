import 'package:client/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartSample extends StatefulWidget {
  final List<Map<String, int>> data;
  final List<Color> colors;
  final bool showPercentage;

  const PieChartSample({
    super.key,
    required this.data,
    required this.colors,
    required this.showPercentage,
  });

  @override
  PieChartSampleState createState() => PieChartSampleState();
}

class PieChartSampleState extends State<PieChartSample> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total =
        widget.data.fold<int>(0, (sum, element) => sum + element.values.first);

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartSize = constraints.maxWidth * 0.6;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                width: chartSize,
                height: chartSize,
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
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: chartSize * 0.2, // Center space radius
                    sections: _showingSections(total),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0,
              runSpacing: 16.0,
              children: widget.data.asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value.keys.first;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    double maxIndicatorWidth =
                        MediaQuery.of(context).size.width / 5;

                    return ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxIndicatorWidth),
                      child: Indicator(
                        color: widget.colors[index],
                        text:
                            "$label (${widget.showPercentage ? '${(entry.value.values.first / total * 100).toStringAsFixed(1)}%' : entry.value.values.first.toString()})",
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
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
        showTitle: false,
        // title:
        //     '${widget.showPercentage ? '${(value / total * 100).toStringAsFixed(1)}%' : value}',
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
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          text[0].toUpperCase() + text.substring(1),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }
}
