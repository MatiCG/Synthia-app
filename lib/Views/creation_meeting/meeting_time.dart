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
    );
  }

  /* '${DateFormat('EEEE, d MMMM').format(edit.date!)}\t\t${_formatTime(edit.startAt!)} - ${_formatTime(edit.endAt!)}'),   */
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

/*
class MeetingTime extends StatefulWidget {
  final Meeting edit;

  const MeetingTime({required this.edit}) : super();

  @override
  _MeetingTimeState createState() => _MeetingTimeState();
}

class _MeetingTimeState extends State<MeetingTime> {
  late Meeting edit = widget.edit;

  String _formatTime(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const IconButton(icon: Icon(Icons.access_time), onPressed: null,),
      title: Text(
          '${DateFormat('EEEE, d MMMM').format(edit.date!)}\t\t${_formatTime(edit.startAt!)} - ${_formatTime(edit.endAt!)}'),
      onTap: () async {
        DateTime? date;
        TimeOfDay? startAt;
        TimeOfDay? endAt;

        date = await showDatePicker(
          context: context,
          initialDate: edit.date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          // Show next Step
          startAt = await showTimePicker(
            context: context,
            initialTime: edit.startAt ?? TimeOfDay.now(),
          );
          endAt = await showTimePicker(
            context: context,
            initialTime: edit.endAt ?? TimeOfDay.now(),
          );
        }
        if (date != null && startAt != null && endAt != null) {
          setState(() {
            edit.startAt = startAt;
            edit.endAt = endAt;
            edit.date = date;
          });
        }
      },
    );
  }
}
*/