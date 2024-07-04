import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileNumberController = TextEditingController();

  void _sendOtp() async {
    final response = await http.post(
      Uri.parse('http://34.93.202.185:5000/api/v1/mobile_otp_login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'mobile_number': _mobileNumberController.text,
      }),
    );

    print('HTTP Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}'); // Debugging statement

    if (response.statusCode == 200) {
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: _mobileNumberController.text,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            ElevatedButton(
              onPressed: _sendOtp,
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
