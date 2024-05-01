class DashboardData {
  final String sensorId;
  final double waterFlowSpeed;
  final double airPressure;
  final double feelLikeTemperature;
  final double realTemperature;
  final double humidity;
  final double waterLevel;
  final double totalWater;
  final double ultravioletIntensity;
  final double luminousIntensity;
  final double altitude;
  final String time;

  DashboardData({
    required this.sensorId,
    required this.waterFlowSpeed,
    required this.airPressure,
    required this.feelLikeTemperature,
    required this.realTemperature,
    required this.humidity,
    required this.waterLevel,
    required this.totalWater,
    required this.ultravioletIntensity,
    required this.luminousIntensity,
    required this.altitude,
    required this.time,
  });
}
