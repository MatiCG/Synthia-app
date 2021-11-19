import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/meeting.dart';
import 'package:synthiapp/Widgets/textfield.dart';
import 'package:uuid/uuid.dart';

class MeetingOrder extends StatefulWidget {
  final Meeting edit;

  const MeetingOrder({required this.edit}) : super();

  @override
  _MeetingOrderState createState() => _MeetingOrderState();
}

class _MeetingOrderState extends State<MeetingOrder> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.edit.order);
  String filepath = '';

  @override
  Widget build(BuildContext context) {
    return _buildField();
  }

  Widget _buildField() {
    return SynthiaTextField(
      padding: const EdgeInsets.only(left: 16, right: 16),
      /*
      onChange: (text) {
        widget.edit.order = text ?? widget.edit.order;
      },
      */
      field: SynthiaTextFieldItem(
        title: 'Ordre du jour',
        textController: _controller,
        onChange: (text) {
          log('TEXT: $text');
          widget.edit.order = text;
        },
        trailing: IconButton(
          icon: const Icon(Icons.file_download_outlined),
          onPressed: () async {
            final FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null && result.paths[0] != null) {
              filepath = await uploadFile(result.paths[0]!);
              setState(() {
                _controller.text = filepath;
                widget.edit.order = _controller.text;
              });
            }
          },
        ),
      ),
    );
  }

  Future<String> uploadFile(String filePath) async {
    final File file = File(filePath);
    String path = '';

    if (!widget.edit.order.contains('orders/')) {
      final uid = const Uuid().v4();
      path = 'orders/$uid/order.pdf';
    } else {
      path = widget.edit.order;
    }

    try {
      await FirebaseStorage.instance.ref(path).putFile(file);
    } on FirebaseException {
      log('Error');
    }
    return path;
  }
}
