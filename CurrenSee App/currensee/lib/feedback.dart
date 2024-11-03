// import 'package:currensee/login.dart';
import 'package:currensee/model/database.dart';
import 'package:currensee/welcome.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CurrenSee",
    home: Feedback_form(),
  ));
}

class Feedback_form extends StatefulWidget {
  const Feedback_form({Key? key}) : super(key: key);

  @override
  _Feedback_formState createState() => _Feedback_formState();
}

class _Feedback_formState extends State<Feedback_form> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name_text = TextEditingController();
  TextEditingController fdb_text = TextEditingController();
  TextEditingController email_text = TextEditingController();
  String _rating = 'Excellent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: Text(
              'User Feedback Form',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 58, 47, 33)),
            ),
            backgroundColor: Colors.teal.shade500,
            foregroundColor: Colors.white,
            centerTitle: true),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: name_text,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name_text = name_text;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: email_text,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email_text = email_text;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: fdb_text,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      labelText: 'Feedback',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your feedback';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fdb_text = fdb_text;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    style: TextStyle(color: Colors.white),
                    // focusColor: Colors.blue,

                    dropdownColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Rating',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    value: _rating,
                    items: ['Excellent', 'Good', 'Average', 'Poor']
                        .map((rating) => DropdownMenuItem(
                              value: rating,
                              child: Text(rating),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _rating = value!;
                      });
                    },
                    onSaved: (value) {
                      _rating = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  // SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                              color: Colors.teal,
                              width: 1.0), // Teal border color
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(100, 100)), // Square shape with 100x100 size
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Square shape with no rounded corners
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.teal; // Filled teal color on hover
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
                                .teal; // Teal text color when not hovered
                          },
                        ),
                      ),
                    onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          String cusid = randomAlphaNumeric(4);
                          Map<String, dynamic> cusrec = {
                            "fbid": cusid,
                            "Name": name_text.text,
                            "Email": email_text.text,
                            "Feedback": fdb_text.text,
                            "Rating": _rating
                          };

                          DatabaseModel()
                              .addfeedback(cusrec, cusid)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Thank you! Received your feedback.'),
                                backgroundColor: Colors.teal,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Welcome()),
                            );
                          });
                        }
                      },

                      child: Text('Submit'),
                    ),
                  ),

                  //     // if (_formKey.currentState!.validate()) {
                  //     //   _formKey.currentState!.save();
                  //     // Process data (e.g., send it to a server or display a success message)
                  //     // ScaffoldMessenger.of(context).showSnackBar(
                  //     //   SnackBar(content: Text('Feedback submitted successfully')),
                  //     // );
                  //   },
                  //   child: Text(
                  //     'Submit',
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
