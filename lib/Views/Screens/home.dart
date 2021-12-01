import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Controllers/screens/home.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Views/home/grid_box.dart';
import 'package:synthiapp/Views/home/home_header.dart';
import 'package:synthiapp/Views/home/meetings_extend.dart';
import 'package:synthiapp/Widgets/header_section.dart';
import 'package:synthiapp/Widgets/list.dart';
import 'package:synthiapp/Widgets/list_meeting_item.dart';
import 'package:synthiapp/config/config.dart';

class HomePage extends StatefulWidget {
  const HomePage() : super();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController? _controller;
  late StreamSubscription subscription;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _controller = HomeController(this);
    });

    subscription =
        SynthiaFirebase().fetchStreamMeetings().listen((event) async {
      final List<Meeting> meetings =
          await _controller!.parseMeetingFromSnapshots(event);

      for (final meeting in meetings) {
        if (_controller!.model.meetings
            .where((element) => element.document!.id == meeting.document!.id)
            .isEmpty) {
          if (mounted) {
            setState(() {
              _controller!.model.meetings.add(meeting);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(backgroundColor: Theme.of(context).primaryColor);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Wrap(
          children: [
            HomeHeader(controller: _controller!),
            HomeGridBox(controller: _controller!),
            _buildListSection(context),
          ],
        ),
      ),
    );
  }

  Hero _buildListSection(BuildContext context) {
    return Hero(
      tag: 'extend_meetings',
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy < 0 && details.delta.distance >= 25) {
            utils.pushScreen(
              context,
              HomeMeetingExtend(
                controller: _controller!,
              ),
            );
          }
        },
        child: Material(
          color: Theme.of(context).primaryColor,
          child: SynthiaList(
            isScrollable: false,
            itemCount: _controller!.model.meetings.length,
            itemBuilder: (index) => ListMeetingItem(
              meeting: _controller!.model.meetings[index],
            ),
            header: HeaderSection(
              title: 'Réunions',
              trailing: _buildSectionTrailing(context),
            ),
          ),
        ),
      ),
    );
  }

  Padding? _buildSectionTrailing(BuildContext context) {
    if (_controller!.model.meetings.length <= 1) return null;
    return Padding(
      padding: const EdgeInsets.only(right: 32.0, top: 8),
      child: InkWell(
        onTap: () {
          utils.pushScreen(
              context,
              HomeMeetingExtend(
                controller: _controller!,
              ));
        },
        child: const Text(
          'Voir tout',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
