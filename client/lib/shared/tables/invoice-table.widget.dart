import 'package:client/shared/tables/base-table.widget.dart';
import 'package:flutter/material.dart';

class CustomizedInvoiceTable extends StatelessWidget {
  final List<EventTableCustom> events;

  const CustomizedInvoiceTable({required this.events, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTable<EventTableCustom>(
      title: "Invoices",
      data: events,
      columns: [
        ColumnDefinition<EventTableCustom>(
          title: "ID",
          valueExtractor: (event) => event.id.toString(),
        ),
        ColumnDefinition<EventTableCustom>(
          title: "Category",
          valueExtractor: (event) => event.categoryName,
        ),
        ColumnDefinition<EventTableCustom>(
          title: "Priority",
          valueExtractor: (event) => event.priority,
          cellBuilder: (priority) {
            Color bgColor = _getPriorityColor(priority);
            return Container(
              padding: const EdgeInsets.all(12.0),
              color: bgColor,
              child: Text(
                priority,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      case "low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class EventTableCustom {
  final int id;
  final String categoryName;
  final String priority;

  EventTableCustom({
    required this.id,
    required this.categoryName,
    required this.priority,
  });
}
