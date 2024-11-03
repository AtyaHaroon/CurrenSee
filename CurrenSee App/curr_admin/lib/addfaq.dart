import 'package:curr_admin/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Addfaq(),
    );
  }
}

class Addfaq extends StatefulWidget {
  const Addfaq({Key? key}) : super(key: key);

  @override
  _AddfaqState createState() => _AddfaqState();
}

class _AddfaqState extends State<Addfaq> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ques = TextEditingController();
  TextEditingController ans = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: Text(
                //     "Add FAQ's",
                //     style: TextStyle(fontSize: 30, color: Colors.teal.shade900),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: ques,
                  style: TextStyle(color: Colors.teal),
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    labelStyle: TextStyle(color: Colors.teal),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Question';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: ans,
                  style: TextStyle(color: Colors.teal),
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    labelStyle: TextStyle(color: Colors.teal),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Answer';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                            color: Colors.teal,
                            width: 1.0), // teal border color
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(100, 100)), // Square shape with 100x100 size
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Square shape with no rounded corners
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors
                                .teal; // Filled teal color on hover
                          }
                          return Colors
                              .transparent; // Transparent background when not hovered
                        },
                      ),
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.white; // White text color on hover
                          }
                          return Colors
                              .teal; // teal text color when not hovered
                        },
                      ),
                    ),
                   onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String cusid = randomAlphaNumeric(4);
                        Map<String, dynamic> cusrec = {
                          "Id": cusid,
                          "Question": ques.text,
                          "Answer": ans.text,
                        };
                        print(cusrec);
                        DatabaseModel().addfaq(cusrec, cusid).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Center(child: Text('FAQ added successfully')),
                              backgroundColor: Colors.teal,
                              duration: Duration(seconds: 6),
                            ),
                          );
                          // Clear the input fields
                          ques.clear();
                          ans.clear();
                          // Optionally, reset the form state
                          _formKey.currentState?.reset();
                        });
                      }
                    },

                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
