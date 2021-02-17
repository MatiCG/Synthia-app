import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:synthiaapp/Controllers/home.dart';
import 'package:synthiaapp/Views/detail_page.dart';
import 'package:synthiaapp/Views/meeting_creation.dart';
import 'package:synthiaapp/config.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _controller;

  @override
  void initState() {
    super.initState();

    _controller = HomeController(parent: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: buildListView(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build header for list view
  Widget buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildLeftItem(),
            buildRightItem(),
          ],
        ),
      ),
    );
  }

  /// Build right item for listview header
  Widget buildRightItem() {
    return Padding(
      padding: const EdgeInsets.only(right: 25, top: 10),
      child: FlatButton(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'Create New',
          style: Theme.of(context).textTheme.headline4,
        ),
        onPressed: () async {
          await utils.futurePushScreen(context, MeetingCreation());
          _controller.updateMeetingList();
        },
      ),
    );
  }

  /// Build left item for listview header
  Widget buildLeftItem() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 10),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          Text(
            'Today',
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            _controller.getTodayMeetings(),
            style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }

  /// Build listview with all meetings
  Widget buildListView() {
    if (_controller.model.meetings.length == 0) {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.5,
          child: LottieBuilder.network(
            'https://assets7.lottiefiles.com/temporary_files/PH5YkW.json',
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: _controller.model.meetings.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 6.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: buildItemList(_controller.model.meetings[index]),
            ),
          ),
        );
      },
    );
  }

  /// Build meetings element for listview
  ListTile buildItemList(DocumentSnapshot meeting) {
    return ListTile(
      title: Row(
        children: [
          Icon(
            Icons.work_outline,
            color: Theme.of(context).primaryColorDark,
          ),
          Container(width: 20),
          Text(
            meeting.data()['title'],
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Row(
          children: [
            buildDetails('Schedule at:', _controller.getMeetingDate(meeting)),
            Container(width: 20),
            buildDetails('Leader:', _controller.getMeetingLeader(meeting)),
          ],
        ),
      ),
      onTap: () => utils.pushScreen(context, DetailPage(post: meeting)),
    );
  }

  /// Build details elements for meeting item in list
  Widget buildDetails(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }
}
