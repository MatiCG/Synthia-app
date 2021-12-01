import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:synthiapp/Controllers/screens/home.dart';

class Calendar extends StatefulWidget {
  final HomeController controller;


  const Calendar({
    required this.controller,
  }) : super();

  @override
  State<Calendar> createState() => _Calendar();
}

class _Calendar extends State<Calendar> {


  @override
  Widget build(BuildContext context) {
    widget.controller.getAllMeetings();
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Calendrier"),
        ),

        body: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          monthViewSettings: MonthViewSettings(showAgenda: true),
          allowedViews: const [
            CalendarView.schedule,
            CalendarView.month,
          ],
          appointmentTimeTextFormat: 'HH:mm',
          dataSource: widget.controller.getCalendarDataSource(),
        ));
  }
}