import 'package:firebase_app2/firestore/daily_graph.dart';
import 'package:firebase_app2/firestore/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app2/firestore/add_bloodglucoselevels.dart';
import 'package:firebase_app2/firestore/add_bloodglucoselevels.dart';
import 'package:firebase_app2/firestore/login_screen.dart';
import 'package:firebase_app2/firestore/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Glucose Monitoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => Addbloodglucoselevels(),
      },
    );
  }
}
