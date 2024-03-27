import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      title: 'Damsel Fly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Dashboard(title: 'Sea Cycle Valve Dashboard'),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
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
        future: Provider.of<DashboardProvider>(context, listen: true)
            .fetchDashboardData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error
            return Text('Error: ${snapshot.error}'); // Display the error code
          } else {
            final dashboardData = snapshot.data;
            // initialize dashboardData with default value
            if (dashboardData == null) {
              return const Center(child: Text('No data'));
            }
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
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
        
    // Initialize the controller with the current settings
    SettingsData settingsData = Provider.of<DashboardProvider>(context, listen: false).settingsData ?? SettingsData(
      userId: 'abc123',
      unitSettings: 'Celcius',
      updateTime: '26-03-2024',
      updateInterval: '1',
      flowControlStatus: 0,
    );
    
    TextEditingController userIdController =
        TextEditingController(text: settingsData.userId);
    TextEditingController unitSettingsController =
        TextEditingController(text: settingsData.unitSettings);
    TextEditingController updateTimeController =
        TextEditingController(text: settingsData.updateTime);
    TextEditingController updateIntervalController =
        TextEditingController(text: settingsData.updateInterval);
    TextEditingController flowControlStatusController =
        TextEditingController(text: settingsData.flowControlStatus.toString());

    return Scaffold(
        body: Form(
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
              // show text that the settings have been updated
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings have been updated'),
                ),
              );
            },
          ),
          // Back to dashboard button
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Back to Dashboard'))
        ],
      ),
    ));
  }
}
