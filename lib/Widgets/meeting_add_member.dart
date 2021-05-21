import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Views/creation_meeting/handle_members.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';

class MeetingAddMembersItem {
  final List<DocumentReference> members;
  DateTime time;

  MeetingAddMembersItem({
    required this.members,
    required this.time,
  });
}

class MeetingAddMembers extends StatefulWidget {
  final MeetingAddMembersItem item;

  MeetingAddMembers({required this.item}) : super();

  @override
  _MeetingAddMembersState createState() => _MeetingAddMembersState();
}

class _MeetingAddMembersState extends State<MeetingAddMembers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Text(
              'Ajouter des participants',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: List.generate(
                      widget.item.members.length >= 5
                          ? 6
                          : widget.item.members.length + 1, (index) {
                    if (index == 0)
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: HandleMembers(widget.item.members),
                                  );
                                });
                            setState(() {
//                              widget.item.members.add(newMemeber);
                              // add new member here
//                              widget.item.members.add('ok');
                            });
                          },
                        ),
                      );
                    index -= 1;
                    if (index + 1 > 4) {
                      return Positioned(
                        left: (20 * index) + 75,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Center(
                            child: Text('+${widget.item.members.length - 4}',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    }
                    return Positioned(
                      left: (20 * index) + 75,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Center(
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.item.members[index].id)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return BuildAvatar(
                                  isRounded: true,
                                  path: (snapshot.data as DocumentSnapshot<
                                          Map<String, dynamic>>)
                                      .data()?['photoUrl'],
                                );
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).accentColor,
                ),
                child: InkWell(
                  onTap: () async {
                    DateTime? date;
                    TimeOfDay? time;

                    date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    print('Date: $date');
                    if (date != null) {
                      time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    }
                    if (time != null) {
                      setState(() {
                        widget.item.time = date!.add(
                            Duration(hours: time!.hour, minutes: time.minute));
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '${widget.item.time.day}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${DateFormat('MMMM').format(widget.item.time)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'à ${DateFormat("H_m").format(widget.item.time)}'
                                .replaceAll('_', 'h'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
