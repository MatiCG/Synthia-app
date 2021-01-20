import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Classes/utils.dart';
import 'package:synthiaapp/Controllers/home.dart';
import 'package:synthiaapp/Views/detail_page.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _controller.retrieveMeetingsList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                buildHeader(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,//.grey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: buildListView(),
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              Expanded(child: Container()),
              LinearProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  /// Build header for list view
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildLeftItem(),
              buildRightItem(),
            ],
          ),
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
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'Create New',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {},
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
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '${_controller.getTodayMeetings().length} meetings',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  /// Build listview with all meetings
  ListView buildListView() {
    return ListView.builder(
      itemCount: _controller.getMeetings().length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
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
              child: buildItemList(_controller.getMeetings()[index]),
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
          Icon(Icons.work_outline),
          Container(width: 20),
          Text(
            meeting.data['title'],
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
      onTap: () => Utils().pushScreen(context, DetailPage(post: meeting)),
    );
  }

  /// Build details elements for meeting item in list
  Widget buildDetails(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Theme.of(context).accentColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
