import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/models/event-status.enum.dart';
import 'package:client/shared/models/event.model.dart';
import 'package:client/shared/models/priority.enum.dart';
import 'package:flutter/material.dart';

class InvoiceTableScreen extends StatelessWidget {
  final List<Event> events = [
    Event(
      id: 1,
      uuid: "uuid1",
      status: EventStatus.Discovered,
      host: "localhost",
      port: "8080",
      priority: PriorityLevel.high,
      categoryName: "System Logs",
      creationDate: DateTime.now(),
      lastOccurrence: DateTime.now(),
      assetId: 101,
    ),
    Event(
      id: 2,
      uuid: "uuid2",
      status: EventStatus.Acknowledged,
      host: "192.168.1.1",
      port: "3306",
      priority: PriorityLevel.medium,
      categoryName: "Database Issues",
      creationDate: DateTime.now().subtract(Duration(days: 1)),
      lastOccurrence: DateTime.now(),
      assetId: 102,
    ),
    Event(
      id: 3,
      uuid: "uuid3",
      status: EventStatus.Removed,
      host: "10.0.0.1",
      port: "22",
      priority: PriorityLevel.low,
      categoryName: "Network Alerts",
      creationDate: DateTime.now().subtract(Duration(days: 2)),
      lastOccurrence: DateTime.now(),
      assetId: 103,
    ),
    Event(
      id: 4,
      uuid: "uuid4",
      status: EventStatus.FalsePositive,
      host: "remotehost",
      port: "443",
      priority: PriorityLevel.none,
      categoryName: "User Events",
      creationDate: DateTime.now().subtract(Duration(days: 3)),
      lastOccurrence: DateTime.now(),
      assetId: 104,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Invoices",
            style: AppTheme.titleStyle,
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
                2: FlexColumnWidth(2), // Priority
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
                        _buildDataCell(event.priority.label),
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

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: AppTheme.bodyTextStyle,
      ),
    );
  }
}
