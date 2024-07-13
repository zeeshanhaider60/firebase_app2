import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app2/firestore/monthly_predictedgraph.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_app2/firestore/daily_graph.dart';
import 'package:firebase_app2/firestore/monthly_graph.dart';
import 'package:firebase_app2/firestore/weekly_graph.dart';
import 'package:firebase_app2/firestore/display_bloodglucoselevels.dart';

class Addbloodglucoselevels extends StatefulWidget {
  const Addbloodglucoselevels({super.key});

  @override
  State<Addbloodglucoselevels> createState() => _AddbloodglucoselevelsState();
}

class _AddbloodglucoselevelsState extends State<Addbloodglucoselevels> {
  final _auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final bglevelController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final carbsController = TextEditingController();
  final bolusInsulinController = TextEditingController();
  final basalInsulinController = TextEditingController();
  final noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('bglevel');

  @override
  void initState() {
    super.initState();
    print('Addbloodglucoselevels initState'); // Debugging
  }

  @override
  Widget build(BuildContext context) {
    print('Building Addbloodglucoselevels page'); // Debugging
    return Scaffold(
      appBar: AppBar(title: Text('Blood Glucose Levels')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Name Here',
                    labelText: 'Enter your Name Here',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: bglevelController,
                  decoration: InputDecoration(
                    hintText: 'Enter your Blood Sugar Level',
                    labelText: 'Enter your Blood Sugar Level',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Blood Glucose Reading';
                    } else if (value.length < 2) {
                      return 'Your Blood Glucose Reading must be in two digits';
                    } else if (value.length > 3) {
                      return 'Please Check Your Blood Glucose Reading Again';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: "Select Date",
                          hintText: "Select Date",
                          filled: true,
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: _selectDate,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: timeController,
                        decoration: InputDecoration(
                          labelText: "Select Time",
                          hintText: "Select Time",
                          filled: true,
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: _selectTime,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: carbsController,
                  decoration: InputDecoration(
                    hintText: 'Enter Carb Intake',
                    labelText: 'Enter Carb Intake',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: bolusInsulinController,
                  decoration: InputDecoration(
                    hintText: 'Enter Bolus Insulin Intake',
                    labelText: 'Enter Bolus Insulin Intake',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: basalInsulinController,
                  decoration: InputDecoration(
                    hintText: 'Enter Basal Insulin Intake',
                    labelText: 'Enter Basal Insulin Intake',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Enter Notes Here',
                    labelText: 'Enter Notes Here',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        loading = true;
                      });

                      User? user = _auth.currentUser;
                      String userId = user?.uid ?? '';

                      fireStore.doc(userId).collection('entries').add({
                        'Name': nameController.text,
                        'Blood Glucose Level': bglevelController.text,
                        'Date': dateController.text,
                        'Time': timeController.text,
                        'Carb Intake': carbsController.text,
                        'Bolus Insulin Intake': bolusInsulinController.text,
                        'Basal Insulin Intake': basalInsulinController.text,
                        'Notes': noteController.text,
                      }).then((value) {
                        Fluttertoast.showToast(msg: 'BG Level Added');
                        setState(() {
                          loading = false;
                        });
                      }).catchError((error) {
                        Fluttertoast.showToast(msg: error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  },
                  child: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Add BG Readings'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayDataScreen(),
                      ),
                    );
                  },
                  child: Text('Display BG Readings'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyGraph(),
                      ),
                    );
                  },
                  child: Text('Daily Graph'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeeklyGraph(),
                      ),
                    );
                  },
                  child: Text('Weekly Graph'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonthlyGraph(),
                      ),
                    );
                  },
                  child: Text('Monthly Graph'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonthlyGraph(),
                      ),
                    );
                  },
                  child: Text('Daily Predicted Graph'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        timeController.text = pickedTime.format(context);
      });
    }
  }
}
