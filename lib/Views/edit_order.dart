import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:synthiaapp/Controllers/edit_order.dart';
import 'package:zefyr/zefyr.dart';

class EditOrder extends StatefulWidget {

  final DocumentSnapshot post;

  EditOrder({this.post});

  @override
  _EditOrderState createState()=> _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  final EditOrderController _controller = EditOrderController();
  ZefyrController _zefyrcontroller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller.loadDocument(widget.post).then((document) {
      setState(() {
        _zefyrcontroller = ZefyrController(document);
      });
    });
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = (_zefyrcontroller == null)
        ? Center (child: CircularProgressIndicator())
        : ZefyrScaffold(
      child: ZefyrEditor(
        padding: EdgeInsets.all(16),
        controller: _zefyrcontroller,
        focusNode: _focusNode,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Order"),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _controller.saveDocument(context, _zefyrcontroller, widget.post),
            ),
          )
        ],
      ),
      body: body,
    );
  }
}