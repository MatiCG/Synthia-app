import 'package:flutter/material.dart';
import 'package:synthiapp/Controllers/settings/report.dart';
import 'package:synthiapp/Models/settings/notifications.dart';
import 'package:synthiapp/Widgets/app_bar.dart';
import 'package:synthiapp/Widgets/list_settings_notification_item.dart';
import 'package:synthiapp/Widgets/scroll_list.dart';

class SettingsReport extends StatefulWidget {
  const SettingsReport() : super();

  @override
  _SettingsReportState createState() => _SettingsReportState();
}

class _SettingsReportState extends State<SettingsReport> {
  SettingsReportController? _controller; //= SettingsReportController();

  @override
  void initState() {
    super.initState();

    setState(() {
      _controller = SettingsReportController(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _controller!.model == null) return const Scaffold();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: const SynthiaAppBar(
        title: 'Paramètres de compte rendu',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 4.0),
          child: SynthiaScrollList(
            sections: _controller!.model!.sections,
            headerBuilder: (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                child: Text(
                  _controller!.model!.sections[index].title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
            itemBuilder: (headerIndex, index) {
              return ListSettingsNotificationItem(
                item: _controller!.model!.sections[headerIndex].items[index] as SettingsNotificationItem,
              );
            },
          ),
        ),
      ),
    );
  }
}
