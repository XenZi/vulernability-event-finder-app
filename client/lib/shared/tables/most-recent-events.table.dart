import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/models/event.model.dart';
import 'package:flutter/material.dart';

class MostRecentEventsTable extends StatelessWidget {
  final List<MostRecentEvent> events;

  const MostRecentEventsTable({
    super.key,
    required this.events, // Accept the events as a prop
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.darkerBackgroundColor,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Most Recent Events",
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.darkerBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1), // ID
                1: FlexColumnWidth(2), // Category Name
                2: FlexColumnWidth(1), // Priority
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: AppTheme.textColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              children: [
                // Table Header
                TableRow(
                  decoration: BoxDecoration(
                    color: AppTheme.darkerBackgroundColor,
                  ),
                  children: [
                    _buildHeaderCell("ID"),
                    _buildHeaderCell("Category"),
                    _buildHeaderCell("Priority"),
                  ],
                ),
                // Table Data
                ...events.map((event) => TableRow(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                      ),
                      children: [
                        _buildDataCell(event.id.toString()),
                        _buildDataCell(event.categoryName),
                        _buildDataCell(event.priority.label,
                            backgroundColor: event.priority.color,
                            align: TextAlign.center),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: AppTheme.bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDataCell(String text,
      {Color? backgroundColor, TextAlign? align}) {
    return Padding(
      padding: const EdgeInsets.all(12.0), // Outer padding for the entire cell
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 4.0, vertical: 2.0), // Inner padding around the text
        color: backgroundColor, // Background color directly around the text
        child: Text(
          text,
          style: AppTheme.bodyTextStyle,
          textAlign: align,
        ),
      ),
    );
  }
}
