import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_water/models/dashboard_data.dart';
import 'package:flutter_water/models/settings_data.dart';

class DashboardProvider with ChangeNotifier {
  List<DashboardData> _dashboardData = [];
  late SettingsData _settingsData = SettingsData(
    userId: 'abc123',
    unitSettings: 'Celcius',
    updateTime: '26-03-2024',
    updateInterval: '1',
    flowControlStatus: 0,
  );

  List<DashboardData> get dashboardData {
    return [..._dashboardData];
  }

  SettingsData get settingsData {
    // ignore: unnecessary_null_comparison
    if (_settingsData == null) {
      fetchSettingsData();
    }
    return _settingsData;
  }

  Future<List<DashboardData>> fetchDashboardData() async {
    // final response =
    //    await http.get(Uri.parse('http://localhost:5000/dashboard'));
    // use fake response to test the UI
    final response = http.Response(
        '[{"waterFlowSpeed": 0.0, "airPressure": 0.0, "feelLikeTemperature": 0.0, "realTemperature": 0.0, "humidity": 0.0, "waterLevel": 0.0, "totalWater": 0.0, "time": "00:00:00"}]',
        200);
    // Initialize the default value of the dashboard data
    _dashboardData = [
      DashboardData(
          waterFlowSpeed: 0,
          airPressure: 0,
          feelLikeTemperature: 0,
          realTemperature: 0,
          humidity: 0,
          waterLevel: 0,
          totalWater: 0,
          time: '00:00:00')
    ];
    final responseData = json.decode(response.body);
    _dashboardData = (responseData as List)
        .map((item) => DashboardData(
            waterFlowSpeed: item['waterFlowSpeed'],
            airPressure: item['airPressure'],
            feelLikeTemperature: item['feelLikeTemperature'],
            realTemperature: item['realTemperature'],
            humidity: item['humidity'],
            waterLevel: item['waterLevel'],
            totalWater: item['totalWater'],
            time: item['time']))
        .toList();
    notifyListeners();
    return _dashboardData;
  }

  Future<void> fetchSettingsData() async {
    // final response =
    //     await http.get(Uri.parse('http://localhost:5000/settings'));
    // use fake response to test the UI
    final response = http.Response(
        '[{"waterFlowSpeed": 0.0, "airPressure": 0.0, "feelLikeTemperature": 0.0, "realTemperature": 0.0, "humidity": 0.0, "waterLevel": 0.0, "totalWater": 0.0, "time": "00:00:00"}]',
        200);
    final responseData = json.decode(response.body);
    _settingsData = SettingsData(
      unitSettings: responseData['unitSettings'],
      updateTime: responseData['updateTime'],
      updateInterval: responseData['updateInterval'],
      flowControlStatus: responseData['flowControlStatus'],
      userId: responseData['userID'],
    );
    notifyListeners();
  }
}
