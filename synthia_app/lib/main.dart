import 'package:flutter/material.dart';
import 'root_page.dart';
import 'auth.dart';
import 'Routes/Form/FormRoute.dart';
// Import pages for navBar
import 'Pages/HomePage.dart';
import 'Pages/AccountPage.dart';
import 'Pages/OrganizationPage.dart';

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
  MyHomePage({Key key, this.title, this.auth, this.onSignOut}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _MyHomePageState createState() => _MyHomePageState(auth: auth, onSignOut: onSignOut);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.auth, this.onSignOut});

  final BaseAuth auth;
  final VoidCallback onSignOut;
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

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }
    }
    
    return Scaffold(
      appBar: new AppBar(
          actions: <Widget>[
            new FlatButton(
                onPressed: _signOut,
                child: new Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white))
            )
          ],
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