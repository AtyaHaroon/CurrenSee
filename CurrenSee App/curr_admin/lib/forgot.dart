import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CurrenSee",
    home: ForPass(),
  ));
}

class ForPass extends StatefulWidget {
  const ForPass({Key? key}) : super(key: key);

  @override
  _ForPassState createState() => _ForPassState();
}

class _ForPassState extends State<ForPass> {
  final _formKey = GlobalKey<FormState>();
  String emailError = '';

  final emailcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                child: Text(
                  "Forgot your Password?",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.teal),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    "Enter your email address and we'll email you a link to reset the password",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Container(
                  width: 280,
                  child: TextFormField(
                    controller: emailcontroller,
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: emailError.isEmpty
                                  ? Colors.teal.shade600
                                  : Colors.red,
                              style: BorderStyle.solid)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.teal.shade600,
                              style: BorderStyle.solid)),
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.email_outlined),
                      errorText: emailError.isEmpty ? null : emailError,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          emailError = 'Please enter email address';
                        });
                        return 'Please enter email address';
                      } else if (!value.contains('@') || !value.contains('.')) {
                        setState(() {
                          emailError = 'Invalid email address';
                        });
                        return 'Invalid email address';
                      }
                      setState(() {
                        emailError = '';
                      });
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Container(
            width: 280,
            height: 50,
            child: OutlinedButton(
              style: ButtonStyle(
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
                      color: Colors.teal, width: 1.0), // Teal border color
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(100, 100)), // Square shape with 100x100 size
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Square shape with no rounded corners
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.teal; // Filled teal color on hover
                    }
                    return Colors
                        .transparent; // Transparent background when not hovered
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.white; // White text color on hover
                    }
                    return Colors.teal; // Teal text color when not hovered
                  },
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await auth.sendPasswordResetEmail(
                        email: emailcontroller.text.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('We have sent you a mail check')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}
