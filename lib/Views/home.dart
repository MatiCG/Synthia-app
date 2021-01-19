import 'package:flutter/material.dart';
import 'package:synthiaapp/Classes/utils.dart';
import 'package:synthiaapp/Controllers/home.dart';
import 'package:synthiaapp/Views/root.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _controller.getMeetingsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text('ok'),
                );
              },
            );
          }
          return Column(children: [
            Expanded(child: Container()),
            LinearProgressIndicator(),
          ]);
        },
      ),
    );
  }
}
