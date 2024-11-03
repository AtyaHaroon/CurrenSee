import 'package:curr_admin/database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Showfeedback(),
  ));
}

class Showfeedback extends StatefulWidget {
  const Showfeedback({Key? key}) : super(key: key);

  @override
  _ShowfeedbackState createState() => _ShowfeedbackState();
}

class _ShowfeedbackState extends State<Showfeedback> {
  Stream? Feed_back; // Stream variable

  Future<void> getload() async {
    Feed_back = await DatabaseModel().showfeedback();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getload();
  }

  Widget allrecordfound() {
    double screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: Feed_back,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: screenWidth * 0.95,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey, width: 1),
              columnWidths: {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                  ),
                  children: [
                    buildTableCell(
                        'Name', Colors.teal.shade700, 16, FontWeight.bold),
                    buildTableCell(
                        'Email', Colors.teal.shade700, 16, FontWeight.bold),
                    buildTableCell('Feedback', Colors.teal.shade700, 16,
                        FontWeight.bold),
                    buildTableCell(
                        'Rating', Colors.teal.shade700, 16, FontWeight.bold),
                  ],
                ),
                // Data Rows
                ...snapshot.data.docs.map<TableRow>((ds) {
                  return TableRow(
                    children: [
                      buildTableCell(ds["Name"], Colors.teal.shade600, 16,
                          FontWeight.normal),
                      buildTableCell(ds["Email"], Colors.teal.shade400, 15,
                          FontWeight.normal),
                      buildTableCell(ds["Feedback"], Colors.teal.shade400, 15,
                          FontWeight.normal),
                      buildTableCell(ds["Rating"], Colors.teal.shade400, 15,
                          FontWeight.normal),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTableCell(
      String text, Color color, double fontSize, FontWeight fontWeight) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Feedback'),
      //   backgroundColor: Colors.teal,
      // ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: allrecordfound(),
            ),
          ],
        ),
      ),
    );
  }
}
