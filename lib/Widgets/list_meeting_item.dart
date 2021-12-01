import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Views/Screens/detail_meeting.dart';
import 'package:synthiapp/Classes/utils.dart';
import 'package:synthiapp/Animations/screen_transition.dart';

class ListMeetingItem extends StatelessWidget {
  ListMeetingItem({
    required this.meeting,
  }) : super();

  final utils = Utils();
  final Meeting meeting;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: InkWell(
          onTap: () => utils.pushScreenTransition(context,
              DetailMeetingPage(meeting: meeting), Transitions.upToDown),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffecf0f1),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Text(
                    meeting.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_outlined,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${DateFormat('d MMMM y').format(meeting.date!)} à ${meeting.startAt!.format(context)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                children: [
                              TextSpan(
                                  text: meeting.master,
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const TextSpan(
                                text: ' dirige la réunion',
                              ),
                            ])),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: _getCountDown(meeting)['color'] as Color?,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _getCountDown(meeting)['text'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// Return a json with [color] and [text] data.
  /// 4 possibilities :
  ///   - Red : En cours
  ///   - Vert : Aujourd'hui
  ///   - Orange : > 1 month
  ///   - Brown : Past
  Map _getCountDown(Meeting meeting) {
    final today = DateTime.now();
    final meetingStart = DateTime(
      meeting.date!.year,
      meeting.date!.month,
      meeting.date!.day,
      meeting.startAt!.hour,
      meeting.startAt!.minute,
    );
    final meetingEnd = DateTime(
      meeting.date!.year,
      meeting.date!.month,
      meeting.date!.day,
      meeting.endAt!.hour,
      meeting.endAt!.minute,
    );
    final timeleft = meetingEnd.difference(today);

    final values = [
      {'color': const Color(0xff34495e), 'text': 'Passé'},
      {'color': const Color(0xffd35400), 'text': "Plus d'un mois"},
      {'color': const Color(0xff27ae60), 'text': "Aujourd'hui"},
      {'color': const Color(0xffc0392b), 'text': 'En cours'},
    ];

    if (timeleft.inSeconds <= 0) {
      return values[0];
    } else if (meeting.date!.day == today.day &&
        today.isAfter(meetingStart) &&
        today.isBefore(meetingEnd)) {
      return values[3];
    } else if (today.day == meeting.date!.day) {
      return values[2];
    } else if (timeleft.inDays >= 31) {
      return values[1];
    }
    return {
      'color': const Color(0xfff39c12),
      'text': '${timeleft.inDays + 1} jours'
    };
  }
}
