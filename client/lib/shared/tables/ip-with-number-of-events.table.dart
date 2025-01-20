import 'package:client/core/theme/app_theme.dart';
import 'package:client/shared/models/ip-asset-with-event-number.model.dart';
import 'package:flutter/material.dart';

class IpEventTable extends StatelessWidget {
  final List<HostEvent> ipEventData;

  const IpEventTable({
    super.key,
    required this.ipEventData,
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
            "IP Event Table",
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
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: AppTheme.textColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: AppTheme.darkerBackgroundColor,
                  ),
                  children: [
                    _buildHeaderCell("IP Address"),
                    _buildHeaderCell("Count", align: TextAlign.center),
                  ],
                ),
                ...ipEventData.map((entry) => TableRow(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                      ),
                      children: [
                        _buildDataCell(entry.host),
                        _buildDataCell(entry.eventCount.toString(),
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

  Widget _buildHeaderCell(String text, {TextAlign? align}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: AppTheme.bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
        textAlign: align,
      ),
    );
  }

  Widget _buildDataCell(String text, {TextAlign? align}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: AppTheme.bodyTextStyle,
        textAlign: align,
      ),
    );
  }
}
