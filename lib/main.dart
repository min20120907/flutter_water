import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_water/models/settings_data.dart';
import 'package:flutter_water/models/settings_provider.dart';
import 'package:flutter_water/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/dashboard_data.dart';

Future<void> registerUser(String username, String password, String email,
    BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://163.13.127.50:5000/register'),
    body: {'username': username, 'password': password, 'email': email},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    String status = jsonResponse['status'];
    String message = jsonResponse['message'];

    if (status == 'success') {
      final snackBar = SnackBar(content: Text('Registration Succeed!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } else {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } else {
    final snackBar =
        SnackBar(content: Text('Registration Failed, please try again later'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Widget buildSettingCard(
    String label, TextEditingController userIdController, Icon icon) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Adjust the padding here
      child: TextFormField(
        controller: userIdController,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: icon,
        ),
      ),
    ),
  );
}

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _subscribeToNewsletter = false;

  Widget buildCard(String text, String hint) {
    return TextField(
      controller: getController(text),
      obscureText: text == 'Password' || text == 'Confirm Password',
      decoration: InputDecoration(
        labelText: text,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  TextEditingController getController(String text) {
    switch (text) {
      case 'Username':
        return _usernameController;
      case 'Email':
        return _emailController;
      case 'Password':
        return _passwordController;
      case 'Confirm Password':
        return _confirmPasswordController;
      default:
        throw Exception('Invalid field');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.cyan],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 100,
            ),
            SizedBox(
              height: 24,
            ),
            buildCard('Username', 'Choose a username'),
            SizedBox(
              height: 16,
            ),
            buildCard('Email', 'Enter your Email'),
            SizedBox(
              height: 16,
            ),
            buildCard('Password', 'Choose a password'),
            SizedBox(
              height: 16,
            ),
            buildCard('Confirm Password', 'Confirm your password'),
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value!;
                    });
                  },
                ),
                Text('Agree to terms and conditions'),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _subscribeToNewsletter,
                  onChanged: (value) {
                    setState(() {
                      _subscribeToNewsletter = value!;
                    });
                  },
                ),
                Text('Subscribe to newsletter'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Handle sign up action
                // check if the agree to terms checkbox is checked
                if (!_agreeToTerms) {
                  // show a snackbar with a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please agree to the terms and conditions'),
                    ),
                  );
                  return;
                }
                // check if the password and confirm password match
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  // show a snackbar with a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match'),
                    ),
                  );
                  return;
                }
                // check if the email is valid
                if (!_emailController.text.contains('@')) {
                  // show a snackbar with a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid email address'),
                    ),
                  );
                  return;
                }
                // check if the username is valid
                if (_usernameController.text.isEmpty) {
                  // show a snackbar with a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Username cannot be empty'),
                    ),
                  );
                  return;
                }
                // check if the password is valid
                if (_passwordController.text.isEmpty) {
                  // show a snackbar with a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password cannot be empty'),
                    ),
                  );
                  return;
                }
                // submit the form to the server by GET
                // format: http://163.13.127.50:5000/register?username=tengsnake&password=1234
                registerUser(_usernameController.text, _passwordController.text,
                    _emailController.text, context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Change button background to blue
                shadowColor: Colors.transparent, // Removes shadow from button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Sign Up',
                  style: TextStyle(
                      color: Colors.white)), // Change text color to white
            ),
            SizedBox(
              height: 16,
            ),
            // add a cancel button on the left of sign up
            TextButton(
              onPressed: () {
                // Handle cancel action
                // Go to the login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Change button background to blue
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<String> notifications = [
    'Notification 1',
    'Notification 2',
    'Notification 3',
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                notifications.clear();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.cyan],
          ),
        ),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(notifications[index]),
              onDismissed: (direction) {
                setState(() {
                  notifications.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notification Removed!')),
                );
              },
              background: Container(color: Colors.red),
              child: Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(notifications[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget buildCard(String text, String label) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: TextField(
            controller:
                text == 'Username' ? _usernameController : _passwordController,
            obscureText: text == 'Password',
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.cyan],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.jpg',
                  height: 100,
                ),
                SizedBox(height: 24),
                buildCard('Username', ''),
                SizedBox(height: 16),
                buildCard('Password', ''),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Handle forgot password action
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Change button background to blue
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign up action
                    // Go to the signup page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Change button background to blue
                    shadowColor:
                        Colors.transparent, // Removes shadow from button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Sign Up',
                      style: TextStyle(
                          color: Colors.white)), // Change text color to white
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign in action
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Change button background to blue
                    shadowColor:
                        Colors.transparent, // Removes shadow from button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Sign In',
                      style: TextStyle(
                          color: Colors.white)), // Change text color to white
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 40.0,
          right: 10.0,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // go to settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
          ),
        ),
      ],
    ));
  }
}

Widget buildCard(double value, String label) {
  return SizedBox(
    width: 150, // Set the width of the card
    height: 150, // Set the height of the card
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

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
      future: Provider.of<DashboardProvider>(context, listen: false)
          .fetchDashboardData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error: ${snapshot.error}'); // Display the error code
        } else {
          final dashboardData = snapshot.data as List<DashboardData>;
          // initialize dashboardData with default value
          if (dashboardData.isEmpty) {
            return const Center(child: Text('No data'));
          }
          // Group the data by sensor_id
          Map<String, List<DashboardData>> groupedData = {};
          for (var data in dashboardData) {
            if (!groupedData.containsKey(data.sensorId)) {
              groupedData[data.sensorId] = [];
            }
            groupedData[data.sensorId]!.add(data);
          }
          return ListView.builder(
            itemCount: groupedData.keys.length,
            itemBuilder: (ctx, i) {
              String sensorId = groupedData.keys.elementAt(i);
              return Card(
                child: Column(
                  children: [
                    Text('Sensor ID: $sensorId'),
                    ...groupedData[sensorId]!
                        .map((data) => Wrap(
                              spacing: 8.0, // Horizontal spacing between cards
                              runSpacing: 8.0, // Vertical spacing between cards
                              children: [
                                buildCard(
                                    data.realTemperature, 'Real Temperature'),
                                buildCard(
                                    data.waterFlowSpeed, 'Water Flow Speed'),
                                buildCard(data.airPressure, 'Air Pressure'),
                                buildCard(data.feelLikeTemperature,
                                    'Feel-like Temperature'),
                                buildCard(data.humidity, 'Humidity'),
                                buildCard(data.waterLevel, 'Water Level'),
                                buildCard(data.totalWater, 'Total Water'),
                                buildCard(data.ultravioletIntensity,
                                    'Ultraviolet Intensity'),
                                buildCard(data.luminousIntensity,
                                    'Luminous Intensity'),
                                buildCard(data.altitude, 'Altitude'),
                                // Add more cards as needed
                              ],
                            ))
                        .toList(),
                  ],
                ),
              );
            },
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
                Navigator.push(
                  // push the notifications page
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsView()),
                );
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
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
                        ),
                        const SizedBox(height: 20),
                        // Sign in button
                        ElevatedButton(
                          onPressed: () {
                            // Handle sign in action
                            // Go to the login page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginView()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary:
                                Colors.blue, // Change button background to blue
                            shadowColor: Colors
                                .transparent, // Removes shadow from button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Sign In',
                              style: TextStyle(
                                  color: Colors
                                      .white)), // Change text color to white
                        ),
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
                // navigate to notifications page
                Navigator.push(
                  // push the notifications page
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsView()),
                );
                break;
              case 3:
                // 導航到Settings頁面
                break;
            }
          },
        ));
  }
}
