import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_water/providers/dashboard_provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DashboardProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: FutureBuilder(
          future: Provider.of<DashboardProvider>(context, listen: false)
              .fetchDashboardData(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              var dashboardData =
                  Provider.of<DashboardProvider>(context).dashboardData;
              return ListView.builder(
                itemCount: dashboardData.length,
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    leading: Text(
                        'Water Flow Speed: ${dashboardData[i].waterFlowSpeed}'),
                    title:
                        Text('Air Pressure: ${dashboardData[i].airPressure}'),
                    subtitle: Text(
                        'Feel-like Temperature: ${dashboardData[i].feelLikeTemperature}'),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (ctx, dashboardData, child) => ListView(
        children: [
          ListTile(
            leading: Text(
                'Unit Settings: ${dashboardData.settingsData.unitSettings}'),
            title:
                Text('Update Time: ${dashboardData.settingsData.updateTime}'),
            subtitle: Text(
                'Update Interval: ${dashboardData.settingsData.updateInterval}'),
          ),
          ListTile(
            leading: Text(
                'Flow Control Status: ${dashboardData.settingsData.flowControlStatus}'),
          ),
        ],
      ),
    );
  }
}
