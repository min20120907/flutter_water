import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_water/models/settings_provider.dart';
import 'package:flutter_water/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsData =
        Provider.of<DashboardProvider>(context, listen: false).settingsData;
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final userIdController = TextEditingController(text: settingsData.userId);
    final unitSettingsController =
        TextEditingController(text: settingsData.unitSettings);
    final updateTimeController =
        TextEditingController(text: settingsData.updateTime);
    final updateIntervalController =
        TextEditingController(text: settingsData.updateInterval);
    final flowControlStatusController =
        TextEditingController(text: settingsData.flowControlStatus.toString());

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: userIdController,
            decoration: const InputDecoration(
              labelText: 'User ID',
            ),
          ),
          TextFormField(
            controller: unitSettingsController,
            decoration: const InputDecoration(
              labelText: 'Unit Settings',
            ),
          ),
          TextFormField(
            controller: updateTimeController,
            decoration: const InputDecoration(
              labelText: 'Update Time',
            ),
          ),
          TextFormField(
            controller: updateIntervalController,
            decoration: const InputDecoration(
              labelText: 'Update Interval',
            ),
          ),
          TextFormField(
            controller: flowControlStatusController,
            decoration: const InputDecoration(
              labelText: 'Flow Control Status',
            ),
          ),
          ElevatedButton(
            child: const Text('Update Settings'),
            onPressed: () {
              settingsProvider.updateSettings(
                userIdController.text,
                unitSettingsController.text,
                updateTimeController.text,
                updateIntervalController.text,
                int.parse(flowControlStatusController.text),
              );
            },
          ),
        ],
      ),
    );
  }
}
