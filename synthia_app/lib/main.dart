import 'package:flutter/material.dart';
import 'Routes/Form/FormRoute.dart';
// Import pages for navBar
import 'Pages/HomePage.dart';
import 'Pages/AccountPage.dart';
import 'Pages/OrganizationPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Meeting list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPage = 0;

  static List<Widget> pages = [
    ListPage(),
    OrganizationPage(),
    AccountPage(),
  ];

  BottomNavigationBarItem createBNBitem(title, icon) {
    return BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: pages.elementAt(selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          createBNBitem('home', Icons.home),
          createBNBitem('organization', Icons.work),
          createBNBitem('account', Icons.account_box),
        ],
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyForm()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}