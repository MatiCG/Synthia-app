import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synthiapp/Classes/meeting.dart';

class MeetingProgressDetails extends StatelessWidget {
  final Meeting meeting;

  const MeetingProgressDetails({required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildTimeDetails(context),
        if (meeting.notes.isNotEmpty) _buildNotesDetails(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meeting.order.contains('pdf')) ...[
              _buildPDFOrderDetails(context),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text('Ordre du jour :',
                    style: _textStyled(context, size: 20)),
              ),
              _buildOrderDetails(),
            ]
          ],
        ),
      ]),
    );
  }

  Widget _buildOrderDetails() {
    return Text(
      meeting.order,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildPDFOrderDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: InkWell(
        onTap: () async {
          final path = meeting.order;
          final reference = FirebaseStorage.instance.ref(path);
          final url = await reference.getDownloadURL();

          final PDFDocument doc = await PDFDocument.fromURL(url);

          await showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: PDFViewer(
                    document: doc,
                  ),
                );
              });
        },
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: "Visualiser l'ordre du jour ",
              style: _textStyled(context, size: 20),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.file_copy_outlined,
                color: Theme.of(context).accentColor,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildNotesDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'Notes de la réunion :',
            style: _textStyled(context, size: 20),
          ),
          TextSpan(
            text: '\n${meeting.notes}',
          ),
        ]),
      ),
    );
  }

  Text _buildTimeDetails(BuildContext context) {
    return Text.rich(TextSpan(children: [
      const TextSpan(text: 'La réunion aura lieu le '),
      TextSpan(
        text: DateFormat('d MMMM y').format(meeting.date!),
        style: _textStyled(context),
      ),
      const TextSpan(text: ' de '),
      TextSpan(
        text: meeting.startAt!.format(context),
        style: _textStyled(context),
      ),
      const TextSpan(text: ' à '),
      TextSpan(
        text: meeting.endAt!.format(context),
        style: _textStyled(context),
      ),
    ]));
  }

  TextStyle _textStyled(BuildContext context, {double size = 14}) {
    return TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.w400,
        fontSize: size);
  }
}
