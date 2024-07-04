import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/otp.dart';
import 'package:flutter_application_1/response_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
          future: _getSessionId(),
          builder: (context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data != null) {
              return HomePage(sessionId: snapshot.data!, vehicleId: ''); // Pass vehicleId if needed
            } else {
              return LoginPage();
            }
          },
        ),
        '/otp': (context) => OtpVerificationPage(),
        '/response': (context) => ResponsePage(),
      },
    );
  }

  Future<String?> _getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }
}
