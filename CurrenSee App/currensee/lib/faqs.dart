import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "CurrenSee",
    home: faq_drop(),
  ));
}

class faq_drop extends StatefulWidget {
  @override
  _faq_dropState createState() => _faq_dropState();
}

class _faq_dropState extends State<faq_drop> {
  Stream<List<FAQItem>>? _faqStream;

  @override
  void initState() {
    super.initState();
    _faqStream = _fetchFAQItems();
  }

  Stream<List<FAQItem>> _fetchFAQItems() {
    return FirebaseFirestore.instance
        .collection('Faq')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FAQItem(
                  question: doc['Question'] ?? 'No Question',
                  answer: doc['Answer'] ?? 'No Answer',
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<List<FAQItem>>(
        stream: _faqStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No FAQs available',
                    style: TextStyle(color: Colors.white)));
          }
          final faqItems = snapshot.data!;
          return Container(
            margin: EdgeInsets.fromLTRB(17, 25, 17, 0),
            child: ListView.builder(
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    faqItems[index].question,
                    style: TextStyle(color: Colors.white),
                  ),
                  children: [
                    Divider(
                      thickness: 1,
                    ),
                    ListTile(
                      title: Text(
                        faqItems[index].answer,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
