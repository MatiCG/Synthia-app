import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/meeting.dart';

class MeetingTime extends StatefulWidget {
  final Meeting meeting;

  const MeetingTime(this.meeting) : super();

  @override
  _MeetingTimeState createState() => _MeetingTimeState();
}

class _MeetingTimeState extends State<MeetingTime> {
  late final Meeting _meeting = widget.meeting;

  Future<DateTime?> datePicker() async {
    return showDatePicker(
      context: context,
      initialDate: _meeting.date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  Future<TimeOfDay?> timePicker() async {
    return showTimePicker(
      context: context,
      initialTime: _meeting.startAt ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildIcon(),
      title: Text(
          '${_formatDate()} ${_formatTime(_meeting.startAt)} - ${_formatTime(_meeting.endAt)}'),
      onTap: () async {
        final DateTime? date = await datePicker();
        final TimeOfDay? startAt = await timePicker();
        final TimeOfDay? endAt = await timePicker();

        if (date != null && startAt != null && endAt != null) {
          setState(() {
            _meeting.date = date;
            _meeting.startAt = startAt;
            _meeting.endAt = endAt;
          });
        }
      },
    );
  }

  String _formatDate() {
    return DateFormat('EEEE, d MMMM').format(_meeting.date ?? DateTime.now());
  }

  String _formatTime(TimeOfDay? time) {
    final TimeOfDay timeOfDay = time ?? TimeOfDay.now();
    return timeOfDay.format(context);
  }

  IconButton _buildIcon() {
    return const IconButton(
      icon: Icon(Icons.access_time),
      onPressed: null,
    );
  }
}