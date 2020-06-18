import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [0].toSet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.post.data["title"])
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
          const SizedBox(height: 30)
        ],
      ),
      ),
    );
  }
}