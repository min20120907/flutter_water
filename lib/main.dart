import 'package:flutter/material.dart';
import 'package:flutter_water/models/settings_data.dart';
import 'package:flutter_water/models/settings_provider.dart';
import 'package:flutter_water/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => DashboardProvider()),
      ChangeNotifierProvider(create: (ctx) => SettingsProvider()),
    ],
    child: const DashboardApp(),
  ));
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Dashboard(title: 'Flutter Demo Home Page'),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final dashboardData =
        Provider.of<DashboardProvider>(context, listen: false).dashboardData;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<DashboardProvider>(context, listen: false)
            .fetchDashboardData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: dashboardData.length,
              itemBuilder: (ctx, i) => Card(
                child: ListTile(
                  leading: Text(
                      'Water Flow Speed: ${dashboardData[i].waterFlowSpeed}'),
                  title: Text('Air Pressure: ${dashboardData[i].airPressure}'),
                  subtitle: Text(
                      'Feel-like Temperature: ${dashboardData[i].feelLikeTemperature}'),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    final settingsData =
        Provider.of<DashboardProvider>(context, listen: false).settingsData;

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
