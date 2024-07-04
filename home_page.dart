import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final String sessionId;
  final String vehicleId;

  HomePage({required this.sessionId, required this.vehicleId});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final storedSessionId = prefs.getString('sessionId');

    if (storedSessionId == null || storedSessionId != sessionId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session expired, please login again.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://34.93.202.185:5000/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'session': sessionId,
        }),
      );

      if (response.statusCode == 200) {
        await prefs.remove('sessionId'); // Clear stored session ID
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout successful')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout')),
        );
      }
    } catch (e) {
      print('Error occurred during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session ID: $sessionId'),
            Text('Vehicle ID: $vehicleId'),
          ],
        ),
      ),
    );
  }
}
