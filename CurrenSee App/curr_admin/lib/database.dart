
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future addfaq(Map<String, dynamic> fq_map, String fqid) async {
    await FirebaseFirestore.instance.collection("Faq").doc(fqid).set(fq_map);
  }

  Future<Stream<QuerySnapshot>> showfeedback() async {
    return await FirebaseFirestore.instance.collection("Feed_back").snapshots();
  }

  Future<Stream<QuerySnapshot>> showfaq() async {
    return await FirebaseFirestore.instance.collection("Faq").snapshots();
  }

  Future<void> upfaq(Map<String, dynamic> updateData, String documentId) async {
    try {
      DocumentReference docRef = _firestore.collection('Faq').doc(documentId);
      DocumentSnapshot doc = await docRef.get();

      if (!doc.exists) {
        throw Exception("Document does not exist");
      }

      await docRef.update(updateData);
    } catch (e) {
      print("Error updating FAQ: $e");
      throw e;
    }
  }

  Future<void> delfaq(String documentId) async {
    try {
      await _firestore.collection('Faq').doc(documentId).delete();
    } catch (e) {
      print("Error deleting FAQ: $e");
      throw e; 
    }
  }
}

