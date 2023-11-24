import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class InitialDisplayDate extends StatelessWidget {
  const InitialDisplayDate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisplayDate(),
    );
  }
}

class DisplayDate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarDisplayDate();
}

class CalendarDisplayDate extends State<DisplayDate> {
  final CalendarController _controller = CalendarController();
  DateTime? _datePicked = DateTime.now();

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });

      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedDate = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });

      // Do something with the selected date and time
      print("Selected Date and Time: $selectedDate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _selectDate(context);
                // showDatePicker(
                //         context: context,
                //         initialDate: _datePicked!,
                //         firstDate: DateTime(2000),
                //         lastDate: DateTime(2100))
                //     .then((DateTime? date) {
                //   if (date != null) _controller.displayDate = date;
                // });
              },
              child: const Icon(
                Icons.date_range,
                //  color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SfCalendar(
                view: CalendarView.week,
                controller: _controller,
                onViewChanged: _viewChanged,
                allowedViews: const [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.workWeek,
                  CalendarView.month,
                  CalendarView.timelineDay,
                  CalendarView.timelineWeek,
                  CalendarView.timelineWorkWeek,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      _datePicked = viewChangedDetails
          .visibleDates[viewChangedDetails.visibleDates.length ~/ 2];
    });
  }
}
