import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Models/screens/home.dart';
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
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_outlined),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat('d MMMM y à').add_Hm().format(meeting.date.toDate()),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
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
                          color: _getCountDown(meeting.date)['color'] as Color?,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _getCountDown(meeting.date)['text'] as String,
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
  ///   - Red : Today
  ///   - Orange : X days
  ///   - Green : > 1 month
  ///   - Brown : Past
  Map _getCountDown(Timestamp meetingTime) {
    final timeleft = meetingTime.toDate().difference(DateTime.now());

    if (timeleft.isNegative) {
      return {'color': Colors.brown, 'text': 'Passé'};
    } else if (timeleft.inDays >= 31 && timeleft.inHours > 24) {
      return {'color': Colors.green, 'text': "Plus d'un mois"};
    } else if (meetingTime.toDate().day == DateTime.now().day && timeleft.inHours <= 24) {
      return {'color': Colors.red, 'text': "Aujourd'hui"};
    } else {
      return {'color': Colors.orange, 'text': '${timeleft.inDays + 1} jours'};
    }
  }
}
