import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerificationPage extends StatefulWidget {
  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();

  void _verifyOtp(String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse('http://34.93.202.185:5000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'mobile_number': mobileNumber,
          'otp_code': _otpController.text,
        }),
      );

      print('HTTP Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}'); // Debugging statement

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        Navigator.pushNamed(
          context,
          '/response',
          arguments: response.body,
        );
      } else {
        print('Failed response: ${response.body}'); // Debugging statement
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (error) {
      print('Error occurred: $error'); // Debugging statement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobileNumber = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP Code'),
            ),
            ElevatedButton(
              onPressed: () => _verifyOtp(mobileNumber),
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
