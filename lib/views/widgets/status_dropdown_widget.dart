import 'package:flutter/material.dart';
import 'package:learning_android_1/data/status_color.dart';

class StatusDropdownWidget extends StatelessWidget {
  final String? selectedStatus;
  final Function(String?) onStatusChanged;

  const StatusDropdownWidget({
    Key? key,
    required this.selectedStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedStatus,
      hint: Text(
        'Status',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      underline: Container(), // Remove underline
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(
            'All',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        ...['Draft', 'Pending', 'Approved', 'Rejected', 'Cancelled'].map((
          String value,
        ) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: StatusColor.getStatusColor(value),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
      onChanged: onStatusChanged,
    );
  }
}
