import 'package:flutter/material.dart';

class BaseTable<T> extends StatelessWidget {
  final List<T> data;
  final List<ColumnDefinition<T>> columns;
  final String title;
  final Widget Function(T)? customRowBuilder;

  const BaseTable({
    required this.data,
    required this.columns,
    required this.title,
    this.customRowBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Table(
              columnWidths: {
                for (int i = 0; i < columns.length; i)
                  i: const FlexColumnWidth(),
              },
              border: TableBorder.all(color: Colors.grey),
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  children: columns
                      .map((col) => _buildHeaderCell(col.title))
                      .toList(),
                ),
                // Data Rows
                ...data.map((item) {
                  if (customRowBuilder != null) {
                    return TableRow(children: [customRowBuilder!(item)]);
                  }
                  return TableRow(
                    children: columns
                        .map((col) => col.cellBuilder != null
                            ? col.cellBuilder!(col.valueExtractor(item))
                            : _buildDataCell(col.valueExtractor(item)))
                        .toList(),
                  );
                }).toList(),
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(text),
    );
  }
}

class ColumnDefinition<T> {
  final String title;
  final String Function(T) valueExtractor;
  final Widget Function(String)? cellBuilder;

  ColumnDefinition({
    required this.title,
    required this.valueExtractor,
    this.cellBuilder,
  });
}
