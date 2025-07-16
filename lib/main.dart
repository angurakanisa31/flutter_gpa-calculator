import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';
// import 'login_screen.dart'; // Uncomment if you use login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for Web or Mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDhZZoWk8ez4WOPnOJa2GeI8_cWgkGIjZY",
        authDomain: "gpacalc-3b82f.firebaseapp.com",
        projectId: "gpacalc-3b82f",
        storageBucket: "gpacalc-3b82f.appspot.com", // ✅ corrected .app to .com
        messagingSenderId: "773244405191",
        appId: "1:773244405191:web:2442899a5c1ac2650a85e2",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(GpaCalculatorApp());
}

class GpaCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(), // Navigate from here to login or home after loading
    );
  }
}
