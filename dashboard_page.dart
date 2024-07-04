import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  final String sessionId;
  final String vehicleId;

  DashboardPage({required this.sessionId, required this.vehicleId});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDashboardData(); 
  }

  Future<void> fetchDashboardData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('http://34.93.202.185:5000/api/v1/get_vehicle_dashboard?vehicle_id=${widget.vehicleId}&session=${widget.sessionId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        dashboardData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
      print('Failed to load dashboard data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Dashboard'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : dashboardData == null
                ? Text('No data available')
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Vehicle ID: ${widget.vehicleId}'),
                          Text('Session ID: ${widget.sessionId}'),
                          SizedBox(height: 20),
                          Text('Dashboard Data:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '${dashboardData!['data']}',
                            style: TextStyle(fontFamily: 'RobotoMono'),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
