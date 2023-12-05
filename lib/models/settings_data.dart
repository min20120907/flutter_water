class SettingsData {
  final String userId;
  final String unitSettings;
  final String updateTime;
  final String updateInterval;
  final int flowControlStatus;

  SettingsData({
    required this.userId,
    required this.unitSettings,
    required this.updateTime,
    required this.updateInterval,
    required this.flowControlStatus,
  });
}
