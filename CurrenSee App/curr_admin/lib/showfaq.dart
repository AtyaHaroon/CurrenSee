import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:curr_admin/addfaq.dart';
import 'package:curr_admin/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Showfaq(),
  ));
}

class Showfaq extends StatefulWidget {
  const Showfaq({Key? key}) : super(key: key);

  @override
  _ShowfaqState createState() => _ShowfaqState();
}

class _ShowfaqState extends State<Showfaq> {
  TextEditingController quesUpdt = TextEditingController();
  TextEditingController ansUpdt = TextEditingController();
  Stream<QuerySnapshot>? faqStream;

  @override
  void initState() {
    super.initState();
    getLoad();
  }

  Future<void> getLoad() async {
    faqStream = await DatabaseModel().showfaq();
    setState(() {});
  }

  Widget allRecordFound() {
    double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: faqStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No records found.'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: screenWidth * 0.95,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
            child: Table(
              border: TableBorder.all(color: Colors.grey, width: 1),
              columnWidths: {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(100),
              },
              children: [
                buildHeaderRow(),
                ...snapshot.data!.docs.map<TableRow>(buildDataRow).toList(),
              ],
            ),
          ),
        );
     
      },
    );
  }

  TableRow buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.teal.shade50),
      children: [
        buildTableCell('Question', Colors.teal.shade700, 16, FontWeight.bold),
        buildTableCell('Answer', Colors.teal.shade700, 16, FontWeight.bold),
        buildTableCell('Actions', Colors.teal.shade700, 16, FontWeight.bold),
      ],
    );
  }

  TableCell buildTableCell(String text, Color color, double fontSize, FontWeight fontWeight) {
    return TableCell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  TableRow buildDataRow(QueryDocumentSnapshot ds) {
    return TableRow(
      children: [
        buildTableCell(ds["Question"], Colors.teal.shade600, 16, FontWeight.normal),
        buildTableCell(ds["Answer"], Colors.teal.shade400, 14, FontWeight.normal),
        TableCell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () async {
                  quesUpdt.text = ds["Question"];
                  ansUpdt.text = ds["Answer"];
                  await getUpdateData(context, ds["Id"]);
                },
              ), 
              Text("|"),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  try {
                    await DatabaseModel().delfaq(ds["Id"]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.teal,
                        content: Center(child: Text("Record Deleted Successfully")),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    print("Error deleting FAQ: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Center(child: Text("Failed to Delete Record")),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('FAQs'),
      //   backgroundColor: Colors.teal,
      // ),
      body: allRecordFound(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Addfaq()),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.teal,
      // ),
    );
  }

  Future<void> getUpdateData(BuildContext context, String editId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Text(
                "Update FAQ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              SizedBox(height: 10),
              buildTextField(quesUpdt, "Question", Icons.question_answer),
              SizedBox(height: 10),
              buildTextField(ansUpdt, "Answer", Icons.comment),
              SizedBox(height: 12),
              Container(
                height: 42,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> updateData = {
                      "Question": quesUpdt.text,
                      "Answer": ansUpdt.text,
                    };
                    try {
                      await DatabaseModel().upfaq(updateData, editId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.teal,
                          content: Center(child: Text("Record Updated Successfully")),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } catch (e) {
                      print("Error updating FAQ: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Center(child: Text("Failed to Update Record")),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text("Update Record"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildTextField(TextEditingController controller, String labelText, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.teal.shade800),
        ),
        prefixIcon: Icon(icon),
        labelText: labelText,
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.teal.shade600),
      ),
    );
  }
}
