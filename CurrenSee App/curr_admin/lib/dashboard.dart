import 'package:curr_admin/addfaq.dart';
import 'package:curr_admin/login.dart';
import 'package:curr_admin/showfaq.dart';
import 'package:curr_admin/showfeedback.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? FinalEmail;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FinalEmail = prefs.getString('sp_email');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FinalEmail == null ? Login() : Dashboard(),
  ));
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  void logout() async {
    SharedPreferences log = await SharedPreferences.getInstance();
    log.remove("sp_email");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          tabController.index == 0
              ? 'Show Feedback'
              : tabController.index == 1
                  ? "Add FAQ's"
                  : 'Show Faq',
          style: TextStyle(
              color: Colors.teal.shade700, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.teal.shade500,
          labelColor: Colors.teal.shade700,
          unselectedLabelColor: Colors.teal.shade300,
          tabs: [
            Tab(
              text: 'Show Feedbacks',
              icon: Icon(
                Icons.question_answer_outlined,
                color: Colors.teal.shade500,
              ),
            ),
            Tab(
              text: "Add FAQ's",
              icon: Icon(
                Icons.queue_sharp,
                color: Colors.teal.shade500,
              ),
            ),
            Tab(
              text: 'Show Faq',
              icon: Icon(
                Icons.new_releases,
                color: Colors.teal.shade500,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Showfeedback(),
          Addfaq(),
          Showfaq(),
        ],
      ),
    );
  }
}
