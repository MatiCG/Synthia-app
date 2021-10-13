import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Views/creation_meeting/handle_members.dart';
import 'package:synthiapp/Widgets/add_members.dart';
import 'package:synthiapp/Widgets/list_members.dart';

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

  const MeetingAddMembers({required this.item}) : super();

  @override
  _MeetingAddMembersState createState() => _MeetingAddMembersState();
}

class _MeetingAddMembersState extends State<MeetingAddMembers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ajouter des participants',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AddMembers(
                members: widget.item.members,
                onLeadingPress: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: HandleMembers(
                          members: widget.item.members,
                        ),
                      );
                    },
                  );
                  setState(() {});
                },
                onTrailingPress: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: ListMembers(
                          members: widget.item.members,
                        ),
                      );
                    },
                  );
                  setState(() {});
                },
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
                    log('Date: $date');
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
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat('MMMM').format(widget.item.time),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'à ${DateFormat("H_m").format(widget.item.time)}'
                                .replaceAll('_', 'h'),
                            style: const TextStyle(
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
