import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_water/models/dashboard_data.dart';
import 'package:flutter_water/models/settings_data.dart';

class DashboardProvider with ChangeNotifier {
  List<DashboardData> _dashboardData = [];
  late SettingsData _settingsData;

  List<DashboardData> get dashboardData {
    return [..._dashboardData];
  }

  SettingsData get settingsData {
    return _settingsData;
  }

  Future<void> fetchDashboardData() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/dashboard'));
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
  }

  Future<void> fetchSettingsData() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/settings'));
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
