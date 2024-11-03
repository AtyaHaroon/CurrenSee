import 'package:currensee/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CurrenSee",
    home: Signup(),
  ));
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController txt_email = TextEditingController();
  final TextEditingController txt_pwd = TextEditingController();
  final TextEditingController txt_cpwd = TextEditingController();
  bool ischeckpass = true;

  final _formKey = GlobalKey<FormState>();

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();

    txt_email.addListener(() {
      setState(() {
        emailError = _validateEmail(txt_email.text);
      });
    });

    txt_pwd.addListener(() {
      setState(() {
        passwordError = _validatePassword(txt_pwd.text);
        confirmPasswordError =
            _validateConfirmPassword(txt_cpwd.text, txt_pwd.text);
      });
    });

    txt_cpwd.addListener(() {
      setState(() {
        confirmPasswordError =
            _validateConfirmPassword(txt_cpwd.text, txt_pwd.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Create New Account",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: txt_email,
                    cursorColor: Colors.teal,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.teal.shade600,
                              style: BorderStyle.solid)),
                      labelText: "Email",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid)),
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) => emailError,
                  ),
                  if (emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        emailError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: txt_pwd,
                    obscureText: ischeckpass,
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.teal.shade600,
                              style: BorderStyle.solid)),
                      labelText: "Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ischeckpass = !ischeckpass;
                            });
                          },
                          icon: ischeckpass
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid)),
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) => passwordError,
                  ),
                  if (passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        passwordError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: txt_cpwd,
                    obscureText: ischeckpass,
                    cursorColor: Colors.teal,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.teal.shade600,
                              style: BorderStyle.solid)),
                      labelText: "Confirm Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ischeckpass = !ischeckpass;
                            });
                          },
                          icon: ischeckpass
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid)),
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) => confirmPasswordError,
                  ),
                  if (confirmPasswordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        confirmPasswordError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 50),
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
                  onPressed: () {
                    setState(() {
                      emailError = _validateEmail(txt_email.text);
                      passwordError = _validatePassword(txt_pwd.text);
                      confirmPasswordError = _validateConfirmPassword(
                        txt_cpwd.text,
                        txt_pwd.text,
                      );
                    });

                    if (_formKey.currentState?.validate() ?? false) {
                      createAccount();
                    }
                  },
                  child: Text('Create Account'),
                ),
              ),
              SizedBox(height: 100),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have An Account?",
                        style: TextStyle(color: Colors.grey)),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Log in",
                          style: TextStyle(color: Colors.teal.shade800),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter email';
    }
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 6 characters long and include uppercase, lowercase, numbers, and special characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String value, String password) {
    if (value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  void createAccount() async {
    String user_email = txt_email.text.trim();
    String user_pwd = txt_pwd.text.trim();

    try {
      UserCredential usercre = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user_email, password: user_pwd);
      if (usercre.user != null) {
        print("Account Created Successfully");
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    } on FirebaseAuthException catch (ex) {
      print(ex.message);
    }
  }
}
