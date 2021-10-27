import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Models/screens/creation_meeting.dart';
import 'package:synthiapp/Models/screens/home.dart';

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
          initialDate: edit.date!,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          // Show next Step
          startAt = await showTimePicker(
            context: context,
            initialTime: edit.startAt!,
          );
          endAt = await showTimePicker(
            context: context,
            initialTime: edit.endAt!,
          );
        }
        if (date != null && startAt != null && endAt != null) {
          setState(() {
            edit.startAt = startAt!;
            edit.endAt = endAt!;
            edit.date = date!;
          });
          /*
          setState(() {
            widget.item.time =
                date!.add(Duration(hours: time!.hour, minutes: time.minute));
          });
          */
        }
      },
    );
  }
}
