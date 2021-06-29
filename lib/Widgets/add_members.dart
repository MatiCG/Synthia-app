import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:synthiapp/Classes/synthia_firebase.dart';
import 'package:synthiapp/Widgets/build_avatar.dart';

class AddMembers extends StatefulWidget {
  final List members;
  final Function()? onLeadingPress;
  final Function()? onTrailingPress;

  const AddMembers({
    required this.members,
    this.onLeadingPress,
    this.onTrailingPress,
  }) : super();

  @override
  _AddMembersState createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -25.0,
      children: List.generate(
        widget.members.length >= 5 ? 6 + 1 : widget.members.length + 2,
        (index) {
          if (index == 0) {
            return _buildAddButton();
          } else if (index == 1) {
            return const SizedBox(width: 75);
          }
          return _buildIcons(index - 2);
        },
      ),
    );
  }

  Widget _buildIcons(int index) {
    if (index >= 4) return _buildCircularIndex();
    if (index <= 3 && index == widget.members.length - 1) {
      return InkWell(
        onTap: widget.onTrailingPress,
        child: _buildUserCircularIcon(index),
      );
    }
    return _buildUserCircularIcon(index);
  }

  Widget _buildCircularIndex() {
    return InkWell(
      onTap: widget.onTrailingPress,
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: Text(
            '+${widget.members.length - 4}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCircularIcon(int index) {
    final SynthiaFirebase _firebase = SynthiaFirebase();

    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: FutureBuilder(
          future: _firebase.fetchUserReferencePhotoUrl(
              widget.members[index] as DocumentReference),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BuildAvatar(
                isRounded: true,
                path: snapshot.data as String? ?? 'assets/avatars/blank.png',
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(),
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.black),
        onPressed: widget.onLeadingPress,
      ),
    );
  }
  /*
    return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: HandleMembers(widget.members as List<DocumentReference>),
                            );
                          });
                      setState(() {
//                              widget.item.members.add(newMemeber);
                        // add new member here
//                              widget.item.members.add('ok');
                      });
                    },
                  ),
                );
              }
  }
    */
  /*
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: List.generate(
                widget.members.length >= 5 ? 6 : widget.members.length + 1, (index) {
              if (index == 0) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: HandleMembers(widget.members as List<DocumentReference>),
                            );
                          });
                      setState(() {
//                              widget.item.members.add(newMemeber);
                        // add new member here
//                              widget.item.members.add('ok');
                      });
                    },
                  ),
                );
              }
              index -= 1;
              if (index + 1 > 4) {
                return Positioned(
                  left: (20 * index) + 75,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                      child: Text('+${widget.members.length - 4}',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }
              return Positioned(
                left: (20 * index) + 75,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                    child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc((widget.members[index] as DocumentReference).id)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          return BuildAvatar(
                            isRounded: true,
                            path: (snapshot.data!
                                    as DocumentSnapshot<Map<String, dynamic>>)
                                .data()?['photoUrl'] as String?,
                          );
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
  */
}
