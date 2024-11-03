import 'package:curr_admin/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CurrenSee",
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPwdController = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();

  final auth = FirebaseAuth.instance;
  bool isPasswordVisible = true;
  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    loginEmailController.addListener(() {
      setState(() {
        emailError = _validateEmail(loginEmailController.text);
      });
    });
    loginPwdController.addListener(() {
      setState(() {
        passwordError = _validatePassword(loginPwdController.text);
      });
    });
    resetEmailController.addListener(() {
      setState(() {
        emailError = _validateEmail(resetEmailController.text);
      });
    });
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPwdController.dispose();
    resetEmailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter email address';
    } else if (!_isValidEmail(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal),
                ),
                SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 280,
                        child: TextFormField(
                          controller: loginEmailController,
                          cursorColor: Colors.teal,
                          style: TextStyle(color: Colors.teal),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: emailError == null
                                    ? Colors.teal.shade600
                                    : Colors.red,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                style: BorderStyle.solid,
                              ),
                            ),
                            labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.teal,
                            ),
                            prefixIcon: Icon(Icons.email_outlined),
                            errorText: emailError,
                          ),
                          validator: (value) => _validateEmail(value!),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 280,
                        child: TextFormField(
                          controller: loginPwdController,
                          obscureText: isPasswordVisible,
                          cursorColor: Colors.teal,
                          style: TextStyle(color: Colors.teal),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: passwordError == null
                                    ? Colors.teal.shade600
                                    : Colors.red,
                                style: BorderStyle.solid,
                              ),
                            ),
                            labelText: "Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: isPasswordVisible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                style: BorderStyle.solid,
                              ),
                            ),
                            labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.teal,
                            ),
                            prefixIcon: Icon(Icons.lock),
                            errorText: passwordError,
                          ),
                          validator: (value) => _validatePassword(value!),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(225, 34, 34, 34),
                      title: Center(
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                      content: Container(
                        height: 140,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Please enter your email address, and we'll send you a link to reset your password.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(height: 10),
                            Form(
                              key: _resetFormKey,
                              child: Container(
                                width: 280,
                                child: TextFormField(
                                  controller: resetEmailController,
                                  cursorColor: Colors.teal,
                                  style: TextStyle(color: Colors.teal),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: emailError == null
                                            ? Colors.teal.shade600
                                            : Colors.red,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.teal.shade600,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.teal,
                                    ),
                                    prefixIcon: Icon(Icons.email_outlined),
                                    errorText: emailError,
                                  ),
                                  validator: (value) => _validateEmail(value!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Reset",
                            style: TextStyle(color: Colors.teal),
                          ),
                          onPressed: () async {
                            if (_resetFormKey.currentState!.validate()) {
                              try {
                                await auth.sendPasswordResetEmail(
                                  email: resetEmailController.text.trim(),
                                );
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.teal,
                                    duration: Duration(seconds: 6),
                                    content: Center(
                                      child: Text(
                                        'We have sent you an email. Please check.',
                                      ),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 6),
                                    content: Center(
                                      child: Text(
                                        e.toString(),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 160),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ),
            SizedBox(height: 80),
            Container(
              width: 280,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.teal, width: 1.0),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: login,
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      String email = loginEmailController.text.trim();
      String password = loginPwdController.text.trim();
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userCredential.user != null) {
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString("sp_email", email);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        }
      } on FirebaseAuthException catch (ex) {
        if (ex.code == 'wrong-password') {
          setState(() {
            passwordError = 'Incorrect password';
          });
        } else if (ex.code == 'user-not-found') {
          setState(() {
            emailError = 'No user found with this email';
          });
        } else {
          setState(() {
            passwordError = 'An error occurred. Please try again.';
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 6),
            content: Center(
              child: Text(
                ex.message ?? 'An error occurred. Please try again.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }
    }
  }
}
