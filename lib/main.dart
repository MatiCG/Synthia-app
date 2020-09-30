import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'root_page.dart';
import 'auth.dart';
// Import pages for navBar
import 'Pages/HomePage.dart';
import 'Pages/AccountPage.dart';
import 'Pages/OrganizationPage.dart';
import 'Pages/TestPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synthia App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: new Auth()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth, this.onSignOut})
      : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(auth: auth, onSignOut: onSignOut);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.auth, this.onSignOut});

  final BaseAuth auth;
  final VoidCallback onSignOut;
  int selectedPage = 0;
  static List<Widget> pages;

  static List<String> pagesName = [
    "Meetings",
    "Organization",
    "Account",
    "Test",
  ];

  BottomNavigationBarItem createBNBitem(title, icon) {
    return BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(icon),
    );
  }
  @override
  void initState() {
    super.initState();

    pages = [
      ListPage(),
      OrganizationPage(),
      AccountPage(onSignOut: widget.onSignOut),
      TestPage(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: pages.elementAt(selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          createBNBitem('home', Icons.home),
          createBNBitem('organization', Icons.work),
          createBNBitem('account', Icons.account_box),
          createBNBitem('mail test', Icons.mail),
        ],
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
