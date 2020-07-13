import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Routes/HomePage/EditOrder.dart';
import 'MultiSelect.dart';
import '../../Services/Mailer.dart';
import '../../auth.dart';

class DetailPage extends StatefulWidget {

  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState()=> _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final auth = new Auth();
  var firestore = Firestore.instance;



  Future<void> sendSynthesis(values, Set<int> selectedValues) async {
    Mailer mailer = new Mailer();
    String user = await auth.currentUserMail();

    for (int i = 0; i < selectedValues.length; i++) {
      int selected = selectedValues.elementAt(i);
      Map<String, dynamic> toJson() =>
      {
        "from": {
          'email': "synthia@no-reply.com",
        },
        "personalizations": [{
          "to": [{
            "email": values[selected]
          }],
          "dynamic_template_data": {
            "email": user,
            "title": widget.post.data["title"]
          }
        }],
        "template_id": "d-bdca15e6acdd40b988f665d7c3bf1c59"
      };
      await mailer.sendMail(toJson());
    }
  }

  Future<void> _showMultiSelect(BuildContext context) async {
    List<String> values= ['matias.castro-guzman@epitech.eu', 'pierre.delsirie@epitech.eu', 'tyliam.silvini@epitech.eu', 'hugo.gagliardi@epitech.eu'];

    final items = <MultiSelectDialogItem<int>>[];

    for (var i = 0; i < values.length; i++) {
        items.add(MultiSelectDialogItem(i, values[i]));
    }

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items
        );
      },
    );

    await sendSynthesis(values, selectedValues);
  }

  Future<void> _showMultiSelectSynthesis(BuildContext context) async {

    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(0, "pdf"),
      MultiSelectDialogItem(1, "docx"),
      MultiSelectDialogItem(2, "odt"),
      MultiSelectDialogItem(3, "txt"),
    ];

    await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [0].toSet(),
        );
      },
    );
  }
  
  emailPopUp(BuildContext context) {
    TextEditingController customController = new TextEditingController();
    
    return showDialog(context: context, builder: (context) {
      return AlertDialog (
        title: Text("Enter Email"),
        content: TextField(
          controller: customController,
        ),
        actions: <Widget>[
          MaterialButton (
            elevation: 5.0,
            child: Text("Share"),
            onPressed: () {
              firestore.collection("meetings").where('title', isEqualTo: widget.post.data['title']).getDocuments().then((QuerySnapshot meetings) {
                firestore.collection("meetings").document(meetings.documents[0].documentID).updateData({"members": FieldValue.arrayUnion([customController.text.toString()])}).then((_) {
                });
              });
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }

  navigateToEditOrder(DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditOrder(post: post,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.post.data["title"]),
            actions: <Widget>[
              Builder(
               builder: (context) => IconButton(
                icon: Icon(Icons.share),
                onPressed: () => emailPopUp(context),
                ),
              )
          ],
      ),
      body: Container(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
          title: Text(widget.post.data["title"]),
          subtitle: Text(widget.post.data["description"]),
          ),
          RaisedButton(
            onPressed: () => _showMultiSelectSynthesis(context),
            child: const Text('Synthesis options', style: TextStyle(fontSize: 20)),
          ),
          RaisedButton(
            onPressed: () => _showMultiSelect(context),
            child: const Text('Send Synthesis', style: TextStyle(fontSize: 20)),
          ),
          RaisedButton(
            onPressed: () => navigateToEditOrder(widget.post),
            child: const Text('Edit Order', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 30)
        ],
      ),
      ),
    );
  }
}