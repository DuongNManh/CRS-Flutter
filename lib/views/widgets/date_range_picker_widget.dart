// lib/views/widgets/date_range_picker_widget.dart
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

class DateRangePickerWidget extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTimeRange) onDateRangeSelected;

  const DateRangePickerWidget({
    Key? key,
    this.startDate,
    required this.endDate,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  late DateTimeRange selectedRange;

  @override
  void initState() {
    super.initState();
    selectedRange = DateTimeRange(
      start:
          widget.startDate ?? DateTime.now().subtract(const Duration(days: 7)),
      end: widget.endDate ?? DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Date Range'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date range display
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        selectedRange.start.toString().split(' ')[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'End Date',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        selectedRange.end.toString().split(' ')[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Calendar
            Expanded(
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.range,
                  selectedDayHighlightColor:
                      Theme.of(context).colorScheme.primary,
                  weekdayLabels: [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ],
                  weekdayLabelTextStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  currentDate: DateTime.now(),
                  selectedDayTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dayTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                value: [selectedRange.start, selectedRange.end],
                onValueChanged: (dates) {
                  if (dates.length == 2 &&
                      dates[0] != null &&
                      dates[1] != null) {
                    setState(() {
                      selectedRange = DateTimeRange(
                        start: dates[0]!,
                        end: dates[1]!,
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedRange = DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 7)),
                    end: DateTime.now(),
                  );
                });
              },
              child: const Text('Last 7 Days'),
            ),
            const SizedBox(width: 16), // Add spacing between buttons
            TextButton(
              onPressed: () {
                setState(() {
                  selectedRange = DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 30)),
                    end: DateTime.now(),
                  );
                });
              },
              child: const Text('Last 30 Days'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed:
                  () => setState(() {
                    selectedRange = DateTimeRange(
                      start: DateTime.now().subtract(const Duration(days: 7)),
                      end: DateTime.now(),
                    );
                  }),
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                widget.onDateRangeSelected(selectedRange);
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }
}
