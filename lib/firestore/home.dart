import 'package:flutter/material.dart';
import 'package:firebase_app2/firestore/add_bloodglucoselevels.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Addbloodglucoselevels(),
              ),
            );
          },
          child: const Text('Add Blood Blucose Readings'),
        ),
      ),
    );
  }
}
