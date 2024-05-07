import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'settings_data.dart';

class SettingsProvider with ChangeNotifier {
  late Database _database;
  late SettingsData _settingsData = SettingsData(
    userId: '',
    unitSettings: '',
    updateTime: '',
    updateInterval: '',
    flowControlStatus: 0,
  );
  SettingsData get settingsData {
    // ignore: unnecessary_null_comparison
    if (_settingsData == null) {
      fetchSettingsData();
    }
    return _settingsData;
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'settings.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE settings(userId TEXT, unitSettings TEXT, updateTime TEXT, updateInterval TEXT, flowControlStatus INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> updateSettings(String userId, String unitSettings,
      String updateTime, String updateInterval, int flowControlStatus) async {
    final response =
        await http.post(Uri.parse('http://163.13.127.50:5000/change_speed'),
            headers: <String, String>{"Content-Type": "application/json"},
            body: json.encode(
              <String, String>{
                'username': 'min20120907',
                'waterspeed': flowControlStatus.toString()
              },
            ));

    print(response.statusCode);
    // if table didnt exist, we init the database

    final Map<String, dynamic> row = {
      'userId': userId,
      'unitSettings': unitSettings,
      'updateTime': updateTime,
      'updateInterval': updateInterval,
      'flowControlStatus': flowControlStatus,
    };

    final existingUser = await _database.query(
      'settings',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (existingUser.isNotEmpty) {
      await _database.update(
        'settings',
        row,
        where: 'userId = ?',
        whereArgs: [userId],
      );
    } else {
      await _database.insert(
        'settings',
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // use http post to change the flow speed
    }
    notifyListeners();
  }

  Future<void> fetchSettingsData() async {
    final List<Map<String, dynamic>> maps = await _database.query('settings');

    if (maps.isNotEmpty) {
      final responseData = maps.first;
      _settingsData = SettingsData(
        unitSettings: responseData['unitSettings'],
        updateTime: responseData['updateTime'],
        updateInterval: responseData['updateInterval'],
        flowControlStatus: responseData['flowControlStatus'],
        userId: responseData['userId'],
      );
      notifyListeners();
    } else {
      throw Exception('No settings found for this user');
    }
  }
}
