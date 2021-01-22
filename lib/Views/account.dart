import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/account.dart';

class AccountPage extends StatefulWidget {
  AccountPage({
    this.authStatusController,
  }) : super();

  final VoidCallback authStatusController;
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountController _controller;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    _controller = AccountController(parent: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                ),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    buildActionsButtonsList(),
                    buildInfoItemsList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build all the input that display the information
  /// about the current user
  Widget buildInfoItemsList() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildInfoItem(
            Icons.perm_identity_outlined,
            'Username',
            _controller.getUserUsername(),
            (String value) => _controller.setUserEditUsername(value),
          ),
          buildInfoItem(
            Icons.phone_iphone_outlined,
            'Phone number',
            _controller.getUserPhoneNumber(),
            null,
          ),
        ],
      ),
    );
  }

  /// Build info textfield for info item list
  Widget buildInfoItem(
      IconData icon, String sectionTitle, String tfValue, Function save) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          sectionTitle,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400
          ),
        ),
        subtitle: Card(
          elevation: isEditing ? 9 : 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              key: Key(tfValue),
              enabled: isEditing,
              initialValue: tfValue,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              validator: validator,
              onSaved: save,
            ),
          ),
        ),
      ),
    );
  }

  /// This function is the validator for TextFormField
  String validator(String value) {
    return value.isEmpty ? 'This field can\'t be empty' : null;
  }

  /// Build all the short buttons for
  /// quick actions
  Widget buildActionsButtonsList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(!isEditing ? Icons.edit_outlined : Icons.save_outlined, () {
          if (isEditing) {
            _controller.submitEdit(_formKey);
          } else {
            setState(() {
              isEditing = !isEditing;
            });
          }
        }),
        buildButton(Icons.email_outlined, null),
        buildButton(Icons.vpn_key_outlined, null),
        buildButton(Icons.logout,
            () => _controller.logout(widget.authStatusController)),
      ],
    );
  }

  /// Build action button for action buttons list
  Widget buildButton(IconData icon, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  /// Build the header for the page
  Widget buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildLeftHeaderItem(),
              Container(width: 25),
              buildRightHeaderItem(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build right item for the header
  Widget buildRightHeaderItem() {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _controller.getUserUsername(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            _controller.getUserEmail(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Build left item for the header
  Widget buildLeftHeaderItem() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: CircleAvatar(
          radius: 45,
          backgroundImage: _controller.getUserProfilePicture().isEmpty
              ? AssetImage('assets/profile.png')
              : NetworkImage(_controller.getUserProfilePicture()),
        ),
      ),
    );
  }
}
