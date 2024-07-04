import 'package:flutter/material.dart';
import 'package:flutter_application_1/find_my_vehicle.dart';
import 'package:flutter_application_1/get_user_details.dart';
import 'dart:convert';
import 'dashboard_page.dart'; // Import the DashboardPage
import 'home_page.dart'; // Import the HomePage

class ResponsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responseBody = ModalRoute.of(context)?.settings.arguments as String? ?? 'No response';

    Map<String, dynamic> responseJson = {};
    try {
      responseJson = jsonDecode(responseBody);
    } catch (e) {
      print('Error decoding JSON: $e');
      responseJson = {
        'error': 'Invalid response format',
        'responseBody': responseBody,
      };
    }

    final sessionId = responseJson['session_id'] ?? '';
    final vehicleId = responseJson['vehicles'] != null && responseJson['vehicles'].isNotEmpty
        ? responseJson['vehicles'][0]['vehicle_id'] ?? ''
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Response Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Response Body: $responseBody'),
            if (responseJson.containsKey('error'))
              Text('Error: ${responseJson['error']}'),
            SizedBox(height: 20),
            if (!responseJson.containsKey('error')) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        sessionId: sessionId,
                        vehicleId: vehicleId,
                      ),
                    ),
                  );
                },
                child: Text('Go to Home Page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(
                        sessionId: sessionId,
                        vehicleId: vehicleId,
                      ),
                    ),
                  );
                },
                child: Text('Go to Vehicle Dashboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetUserDetailsPage(
                        sessionId: sessionId,
                        vehicleId: vehicleId,
                      ),
                    ),
                  );
                },
                child: Text('Go to Get User Details'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindMyVehiclePage(
                        sessionId: sessionId,
                        vehicleId: vehicleId,
                      ),
                    ),
                  );
                },
                child: Text('Go to Find My Vehicle'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
