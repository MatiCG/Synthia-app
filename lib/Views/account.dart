import 'package:flutter/material.dart';
import 'package:synthiaapp/Controllers/account.dart';
import 'package:synthiaapp/Widgets/rounded_image_picker.dart';
import 'package:synthiaapp/config.dart';

/*
body: Stack(
        overflow: Overflow.visible,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.35,
                child: buildHeader(),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: buildInfoItemsList(),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35 - (MediaQuery.of(context).size.height * 0.2 / 2),
            left: MediaQuery.of(context).size.width * 0.025,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.2,
              child: buildActionsButtonsList(),
            ),
          ),
        ],
      ),
*/

class AccountPage extends StatefulWidget {
  AccountPage() : super();

  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountController _controller;
  bool isEditing = false;
  // Value of the size of each section in the stack in percent
  static double headerHeight = 0.4;
  static double overflowHeight = 0.2;
  static double overflowWidth = 0.95;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AccountController(parent: this);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        //overflow: Overflow.visible,
        children: [
          Column(
            children: [
              // Build header of the page
              buildStackHeader(screenWidth, screenHeight),
              // Build the rest of the view
              Expanded(
                child: buildStackContent(screenWidth, screenHeight),
              ),
            ],
          ),
          // Build overflow content (our actions buttons)
          Positioned(
            top: (screenHeight * headerHeight) -
                ((screenHeight * overflowHeight) / 2),
            left: screenWidth * (1.0 - overflowWidth) / 2,
            child: buildStackOverflow(screenWidth, screenHeight),
          ),
        ],
      ),
    );
  }

  /*
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
  */

  /// Show the user his current data like his profile picture, email,
  /// username.
  Widget buildStackHeader(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight * headerHeight,
      color: Theme.of(context).accentColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              // Build image picker that contains the profile picture of the user
              RoundedImagePicker(imagePath: auth.user.photoURL),
              // Display user's displayname
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  auth?.user?.displayName ?? '[No Username]',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              // Display user's email
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _controller.user.email ?? '',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStackContent(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      color: Theme.of(context).primaryColor,
      child: buildInfoItemsList(),
    );
  }

  /// Build overflow buttons
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

  Widget buildStackOverflow(double screenWidth, double screenHeight) {
    IconData editIcon = isEditing ? Icons.save_outlined : Icons.edit_outlined;
    Function editOnPressed = isEditing
        ? () => _controller.submitEdit(_formKey)
        : () {
            setState(() {
              isEditing = !isEditing;
            });
          };

    return Container(
      width: screenWidth * overflowWidth,
      height: screenHeight * overflowHeight,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildButton(editIcon, editOnPressed),
          buildButton(Icons.email_outlined, null),
          buildButton(Icons.vpn_key_outlined, null),
          buildButton(Icons.logout, () => _controller.logout()),
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
            _controller.model.username,
            (String value) => _controller.model.username = value,
          ),
          /*
          buildInfoItem(
            Icons.phone_iphone_outlined,
            'Phone number',
            _controller.model.phonenumber,
            null,
          ),
          */
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
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          sectionTitle,
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w400),
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
  /*
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
        buildButton(Icons.logout,() => _controller.logout()),
      ],
    );
  }
  */

/*
  @override
  Widget build(BuildContext context) {
    test();
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
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

  /// Build header of the page with profile picture and basic
  /// data (username and email)
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

  /// Build left item of the header. Rounded photo url of the user
  Widget buildLeftHeaderItem() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: CircleAvatar(
          radius: 45,
          backgroundImage: NetworkImage(_controller?.user?.photoUrl ??
              'https://i.stack.imgur.com/l60Hf.png'),
        ),
      ),
    );
  }

  /// Build right item for the header. Basic data username and email
  Widget buildRightHeaderItem() {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _controller?.model?.username ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            _controller?.user?.email ?? '',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w200,
              color: Theme.of(context).primaryColor,
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
            _controller.model.username,
            (String value) => _controller.model.username = value,
          ),
          buildInfoItem(
            Icons.phone_iphone_outlined,
            'Phone number',
            _controller.model.phonenumber,
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
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          sectionTitle,
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w400),
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
        buildButton(Icons.logout,() => _controller.logout()),
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
*/
}
