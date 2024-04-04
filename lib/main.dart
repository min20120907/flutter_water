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
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

FutureBuilder dashboard(BuildContext context) {
  return FutureBuilder(
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
            itemBuilder: (ctx, i) => Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${dashboardData[i].realTemperature}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Real Temperature',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign
                                    .center, // This will center align the text
                                maxLines:
                                    2, // This will limit the text to two lines
                                overflow: TextOverflow
                                    .ellipsis, // This will add ellipsis if the text overflows
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${dashboardData[i].waterFlowSpeed}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Water Flow Speed',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign
                                    .center, // This will center align the text
                                maxLines:
                                    2, // This will limit the text to two lines
                                overflow: TextOverflow
                                    .ellipsis, // This will add ellipsis if the text overflows
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 你可以按照上面的模式添加更多的卡片
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${dashboardData[i].airPressure}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Air Pressure',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign
                                    .center, // This will center align the text
                                maxLines:
                                    2, // This will limit the text to two lines
                                overflow: TextOverflow
                                    .ellipsis, // This will add ellipsis if the text overflows
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 你可以按照上面的模式添加更多的卡片

                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${dashboardData[i].feelLikeTemperature}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Feel-like Temperature',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 你可以按照上面的模式添加更多的卡片

                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${dashboardData[i].humidity}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Humidity',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 你可以按照上面的模式添加更多的卡片

                  // Repeat the same pattern for the remaining cards...
                ],
              ),
            ]),
          );
        }
      });
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int index2 = 1;
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.cyan],
            ),
          ),
          child: dashboard(
              context), // call the dashboard function to display the dashboard data
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
          unselectedItemColor:
              Color.fromARGB(255, 123, 159, 173), // Set unselected item color
          selectedItemColor: Colors.purple, // Set selected item color
          // 選擇的項目索引
          currentIndex: index2,
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
                // refresh the page and update index2
                Navigator.push(
                  // push the settings page
                  context,
                  MaterialPageRoute(builder: (context) => SettingsView()),
                );
                break;
            }
          },
        ));
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
          title: const Text('SCV mobile'),
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purple, Colors.cyan],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust the padding here
                            child: TextFormField(
                              controller: userIdController,
                              decoration: const InputDecoration(
                                labelText: 'User ID',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust the padding here
                            child: TextFormField(
                              controller: unitSettingsController,
                              decoration: const InputDecoration(
                                labelText: 'Unit Settings',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.settings),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust the padding here
                            child: TextFormField(
                              controller: updateTimeController,
                              decoration: const InputDecoration(
                                labelText: 'Update Time',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.timer),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust the padding here
                            child: TextFormField(
                              controller: updateIntervalController,
                              decoration: const InputDecoration(
                                labelText: 'Update Interval',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.update),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust the padding here
                            child: TextFormField(
                              controller: flowControlStatusController,
                              decoration: const InputDecoration(
                                labelText: 'Flow Control Status',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.show_chart),
                              ),
                            ),
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
            ),
          ],
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
          unselectedItemColor:
              Color.fromARGB(255, 123, 159, 173), // Set unselected item color
          selectedItemColor: Colors.purple, // Set selected item color
          // 選擇的項目索引
          currentIndex: 3,
          // 點擊項目時的回調
          onTap: (index) {
            // 根據索引執行相應的操作，例如導航到不同的頁面
            switch (index) {
              case 0:
                // 導航到Home頁面
                break;
              case 1:
                // 導航到Dashboard頁面
                // change body to dashboard by dashboard(context)
                Navigator.push(
                  // push the dashboard page
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
                break;
              case 2:
                // 導航到Notifications頁面
                break;
              case 3:
                // 導航到Settings頁面
                break;
            }
          },
        ));
  }
}
