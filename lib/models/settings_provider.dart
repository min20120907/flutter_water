import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SettingsProvider with ChangeNotifier {
  Future<void> updateSettings(String userId, String unitSettings,
      String updateTime, String updateInterval, int flowControlStatus) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/settings'),
      body: {
        'userId': userId,
        'unitSettings': unitSettings,
        'updateTime': updateTime,
        'updateInterval': updateInterval,
        'flowControlStatus': flowControlStatus.toString(),
      },
    );
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to update settings');
    }
  }
}
