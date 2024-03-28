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
                itemBuilder: (ctx, i) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Water Flow Speed',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text('${dashboardData[i].waterFlowSpeed}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Air Pressure',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text('${dashboardData[i].airPressure}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Feel-like Temperature',
                            style: TextStyle(fontSize: 18),
                          ),
                          title:
                              Text('${dashboardData[i].feelLikeTemperature}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Real Temperature',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text('${dashboardData[i].realTemperature}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Humidity',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text('${dashboardData[i].humidity}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Air Pressure',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text('${dashboardData[i].airPressure}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Water Level',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text('${dashboardData[i].waterLevel}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Total Water',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text('${dashboardData[i].totalWater}'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Text(
                            'Time',
                            style: TextStyle(fontSize: 18),
                          ),
                          title: Text(dashboardData[i].time),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            // 選擇的項目索引
            currentIndex: 1,
            // 點擊項目時的回調
            onTap: (index) {
              // 根據索引執行相應的操作，例如導航到不同的頁面
              switch (index) {
                case 0:
                  // 導航到Home頁面
                  break;
                case 1:
                  // 導航到Dashboard頁面
                  break;
                case 2:
                  // 導航到Notifications頁面
                  break;
                case 3:
                  // 導航到Settings頁面
                  break;
              }
            }));
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    // Initialize the controller with the current settings
    SettingsData settingsData;
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    //get settings data from the dashboard provider, if available
    settingsData = dashboardProvider.settingsData;

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
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: userIdController,
                  decoration: const InputDecoration(
                    labelText: 'User ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: unitSettingsController,
                  decoration: const InputDecoration(
                    labelText: 'Unit Settings',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.settings),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: updateTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Update Time',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.timer),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: updateIntervalController,
                  decoration: const InputDecoration(
                    labelText: 'Update Interval',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.update),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: flowControlStatusController,
                  decoration: const InputDecoration(
                    labelText: 'Flow Control Status',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.show_chart),
                  ),
                ),
                const SizedBox(height: 20),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
