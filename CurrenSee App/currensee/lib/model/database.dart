import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseModel {
  Future addfeedback(Map<String, dynamic> fb_map, String fbid) async {
    await FirebaseFirestore.instance
        .collection("Feed_back")
        .doc(fbid)
        .set(fb_map);
  }

  Future<Stream<QuerySnapshot>> showfeedback() async {
    return await FirebaseFirestore.instance.collection("Feed_back").snapshots();
  }

 
}
