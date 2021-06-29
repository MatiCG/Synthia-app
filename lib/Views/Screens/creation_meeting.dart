import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/screens/creation_meeting.dart';
import 'package:synthiapp/Widgets/button.dart';
import 'package:synthiapp/Widgets/list.dart';
import 'package:synthiapp/Widgets/meeting_add_member.dart';
import 'package:synthiapp/Widgets/textfield.dart';

class CreationMeetingPage extends StatefulWidget {
  const CreationMeetingPage() : super();

  @override
  _CreationMeetingPageState createState() => _CreationMeetingPageState();
}

class _CreationMeetingPageState extends State<CreationMeetingPage> {
  final CreateMeetingController _controller = CreateMeetingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _buildTitle(context),
                Positioned(
                  top: 64,
                  width: MediaQuery.of(context).size.width * 0.9,
                  left: 16,
                  child: Center(
                    child: Form(
                      key: _controller.model.formKey,
                      child: SynthiaList(
                        isScrollable: false,
                        itemCount: _controller.model.fields.length,
                        itemBuilder: (index) {
                          if (_controller.model.fields[index]
                              is SynthiaTextFieldItem) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: SynthiaTextField(
                                field: _controller.model.fields[index] as SynthiaTextFieldItem,
                              ),
                            );
                          } else if (_controller.model.fields[index]
                              is MeetingAddMembersItem) {
                            return MeetingAddMembers(
                                item: _controller.model.fields[index] as MeetingAddMembersItem);
                          }
                          return _controller.model.fields[index] as Widget;
                        },
                        footer: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SynthiaButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColor,
                            text: 'Créer la réunion',
                            onPressed: () => _controller.submit(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildTitle(BuildContext context) {
    return Positioned(
      top: 8,
      left: 16,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 24),
          children: [
            const TextSpan(text: 'Créer votre réunion '),
            TextSpan(
              text: 'SynthIA',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
