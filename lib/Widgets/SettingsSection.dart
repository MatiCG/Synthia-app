import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';
import '../Models/User.dart';

class SettingsSection extends StatefulWidget {
  SettingsSection({
    Key key,
    @required this.sectionTitle,
    @required this.titles,
    @required this.subtitles,
    @required this.values,
    @required this.user,
    this.notifications,
  }) : super(key: key);

  final String sectionTitle;
  final List<String> titles;
  final List<String> subtitles;
  final List<bool> values;
  final User user;
  final List<Function> notifications;

  Section createState() => Section();
}

class Section extends State<SettingsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Text(
            widget.sectionTitle,
            style: TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.titles.length,
            itemBuilder: (context, index) {
              if (widget.titles[index] == 'Choisir le format') {
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                  title: Text(widget.titles[index],
                      style: TextStyle(fontSize: 16)),
                  subtitle: Text(
                    widget.subtitles[index],
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                    child: SlidingSwitch(
                      width: 75,
                      height: 35,
                      textOff: 'txt',
                      textOn: 'pdf',
                      colorOff: Colors.white,
                      colorOn: Colors.white,
                      buttonColor: Colors.indigo,
                      value: widget.values[index],
                      onChanged: (val) {
                        setState(() {
                          widget.values[index] = val;
                          if (widget.notifications != null) {
                            widget.notifications[index](val);
                          }
                        });
                      },
                    ),
                  )
                );
              } else {
                return SwitchListTile(
                  dense: false,
                  activeColor: Colors.indigo,
                  contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                  value: widget.values[index],
                  title: Text(widget.titles[index],
                      style: TextStyle(fontSize: 16)),
                  subtitle: Text(
                    widget.subtitles[index],
                    style: TextStyle(fontSize: 13),
                  ),
                  onChanged: (val) {
                    setState(() {
                      widget.values[index] = val;
                      if (widget.notifications != null) {
                        widget.notifications[index](val);
                      }
                    });
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
