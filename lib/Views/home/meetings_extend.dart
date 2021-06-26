import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/home.dart';
import 'package:synthiapp/Widgets/header_section.dart';
import 'package:synthiapp/Widgets/list.dart';
import 'package:synthiapp/Widgets/list_meeting_item.dart';

class HomeMeetingExtend extends StatefulWidget {
  final HomeController controller;

  const HomeMeetingExtend({required this.controller}) : super();

  @override
  _HomeMeetingExtendState createState() => _HomeMeetingExtendState();
}

class _HomeMeetingExtendState extends State<HomeMeetingExtend> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (mounted) {
      scrollController.addListener(() {
        log('scroll: ${scrollController.offset}');
        if (scrollController.offset <= -100) {
          Navigator.of(context).maybePop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Hero(
        tag: 'extend_meetings',
        child: Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy > 0 && details.delta.distance >= 20) {
                Navigator.pop(context);
              }
            },
            child: SynthiaList(
              scrollController: scrollController,
              itemCount: widget.controller.model.meetings.length,
              itemBuilder: (index) => ListMeetingItem(
                meeting: widget.controller.model.meetings[index],
              ),
              header: const HeaderSection(
                title: 'Réunions',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
