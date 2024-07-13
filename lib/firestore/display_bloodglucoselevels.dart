import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayDataScreen extends StatefulWidget {
  @override
  _DisplayDataScreenState createState() => _DisplayDataScreenState();
}

class _DisplayDataScreenState extends State<DisplayDataScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Glucose Readings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('bglevel')
            .doc(_currentUser?.uid)
            .collection('entries')
            .orderBy('Date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Data Found'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('BGL')),
                DataColumn(label: Text('Carb Intake')),
                DataColumn(label: Text('Bolus Insulin Intake')),
                DataColumn(label: Text('Basal Insulin Intake')),
                DataColumn(label: Text('Notes')),
              ],
              rows: documents
                  .map((doc) => DataRow(cells: [
                        DataCell(Text(doc['Date'] ?? '')),
                        DataCell(Text(doc['Time'] ?? '')),
                        DataCell(Text(doc['Blood Glucose Level'] ?? '')),
                        DataCell(Text(doc['Carb Intake'] ?? '')),
                        DataCell(Text(doc['Bolus Insulin Intake'] ?? '')),
                        DataCell(Text(doc['Basal Insulin Intake'] ?? '')),
                        DataCell(Text(doc['Notes'] ?? '')),
                      ]))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
