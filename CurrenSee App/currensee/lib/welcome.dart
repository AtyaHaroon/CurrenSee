import 'package:flutter/material.dart';
import 'package:currensee/allcurrency.dart';
import 'package:currensee/curr.dart';
import 'package:currensee/feedback.dart';
import 'package:currensee/faqs.dart';
import 'package:currensee/history.dart'; 
import 'package:currensee/login.dart';
import 'package:currensee/user_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? FinalEmail;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CurrenSee",
    home: Welcome(),
  ));
}

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _selectedIndex = 1; 
  List<String> _conversionHistory = []; 

  @override
  void initState() {
    super.initState();
    getdataSharedPref().whenComplete(() {});
    get_spvalue();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _conversionHistory = prefs.getStringList('conversionHistory') ?? [];
    });
  }

  Future<void> getdataSharedPref() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainEmail = sharedPreferences.getString("sp_email");
    setState(() {
      FinalEmail = obtainEmail;
    });
  }

  Future<void> get_spvalue() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    setState(() {
      FinalEmail = shared.getString('sp_email');
    });
  }

  void logout() async {
    SharedPreferences log = await SharedPreferences.getInstance();
    log.remove("sp_email");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Welcome()));
  }

  void _updateHistory() {
    _loadHistory();
  }

  List<Widget> _pages() {
    return [
      faq_drop(),
      HomePage(
        onHistoryUpdated: _updateHistory, // Pass callback to update history
      ),
      HistoryPage(history: _conversionHistory), // Pass the history list
    ];
  }

  String _appBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "FAQ's";
      case 1:
        return "Currency Converter";
      case 2:
        return "Conversion History";
      default:
        return "CurrenSee";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade500,
        foregroundColor: Colors.white,
        title: Text(_appBarTitle()), // Set title dynamically
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 8, 10, 12),
          child: ListView(
            children: [
              SizedBox(
                height: 80,
                child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.teal.shade700),
                    child: Column(
                      children: [
                        Text(
                          "CurrenSee",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )),
              ),
              ListTile(
                  leading:
                      Icon(Icons.query_stats_sharp, color: Colors.grey[700]),
                  title: Text(
                    "Currency Rate List",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FinalEmail == null ? Login() : Allcurrency()));
                  }),
              ListTile(
                  leading:
                      Icon(Icons.feedback_outlined, color: Colors.grey[700]),
                  title: Text(
                    "Feedback",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FinalEmail == null
                                ? Login()
                                : Feedback_form()));
                  }),
              ListTile(
                leading: Icon(Icons.settings_suggest_outlined,
                    color: Colors.grey[700]),
                title: Text(
                  "User Preferences",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FinalEmail == null ? Login() : User_pref()));
                },
              ),
              Divider(),
              FinalEmail != null
                  ? ListTile(
                      leading: Icon(Icons.power_settings_new,
                          color: Colors.grey[700]),
                      title: Text(
                        "Logout",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () {
                        logout();
                      },
                    )
                  : ListTile(
                      leading: Icon(Icons.power_settings_new,
                          color: Colors.grey[700]),
                      title: Text(
                        "Login",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: ((context) => Login())));
                      },
                    )
            ],
          ),
        ),
      ),
      body: _pages()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 30,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.tealAccent.shade700,
        unselectedItemColor: Colors.grey[500],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_rounded), label: "FAQ's"),
          BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange_sharp), label: "Converter"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 2) {
              _updateHistory(); // Refresh history data when navigating to History tab
            }
          });
        },
      ),
    );
  }
}
