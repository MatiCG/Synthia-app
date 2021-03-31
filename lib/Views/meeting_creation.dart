import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/meeting_creation.dart';

class MeetingCreation extends StatefulWidget {
  MeetingCreation() : super();

  _MeetingCreationState createState() => _MeetingCreationState();
}

class _MeetingCreationState extends State<MeetingCreation> {
  MeetingCreationController _controller;
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = MeetingCreationController(parent: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).accentColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await _controller.createMeeting()) {
            Navigator.pop(context);
          }
        },
        child: Icon(
          Icons.save,
          color: Theme.of(context).accentColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          buildFormHeader(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.builder(
              itemCount: _controller.model.getMeetingMembers().length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: TextField(
                      controller: _editingController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: 'Enter a member of your organization',
                        suffixIcon: IconButton(
                          color: Theme.of(context).primaryColor,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _controller.addNewMember(_editingController.text);
                            _editingController.clear();
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                String member = _controller.model.getSpecificMember(index - 1);
                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: ListTile(
                    title: Text(
                      member,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    trailing: index - 1 != 0
                        ? IconButton(
                            icon: Icon(Icons.delete_forever,
                                color: Colors.deepOrangeAccent),
                            onPressed: () {
                              setState(() {
                                _controller.model.removeMember(member);
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.admin_panel_settings,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: null,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build the form of the meeting creation
  Widget buildFormHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        margin: const EdgeInsets.all(16.0),
        child: Card(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    buildHeaderItem(context, 'title', _controller),
                    buildHeaderItem(context, 'description', _controller),
                    buildHeaderItem(context, 'order', _controller)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Build header form item
Widget buildHeaderItem(BuildContext context, String section,
    MeetingCreationController controller) {
  String sectionValue = controller.getValueBySection(section);

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextButton(
      onPressed: () {
        buildModal(
          context,
          ModalBuilder(
            context: context,
            section: section,
            controller: controller,
          ),
        );
      },
      child: Column(
        children: [
          Text(
            section,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
          ),
          Text(
            sectionValue != 'Click to modify' && sectionValue.length > 15
                ? sectionValue.substring(0, 15) + '...'
                : sectionValue,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w200,
                fontSize: 15),
          ),
        ],
      ),
    ),
  );
}

/// Build the content of the modal
class ModalBuilder extends StatelessWidget {
  ModalBuilder({
    this.context,
    this.section,
    this.controller,
  });

  final BuildContext context;
  final String section;
  final MeetingCreationController controller;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'Modify the meeting $section',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 20,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: controller.getValueBySection(section),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 4,
                ),
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ElevatedButton(
//            color: Theme.of(context).accentColor,
            child: Text(
              'Validate',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              if (textEditingController.text.isEmpty ||
                  textEditingController.text == 'Click to modify') {
              } else {
                controller.setValueBySection(
                    section, textEditingController.text);
                Navigator.pop(context);
              }
            },
          ),
        ),
      ],
    );
  }
}

/// Create a modal and add a specific widget inside
void buildModal(BuildContext context, Widget builder) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: builder,
            ),
          ),
        ],
      ),
    ),
  );
}