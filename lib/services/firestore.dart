import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
//Get collection of names

  final CollectionReference names =
      FirebaseFirestore.instance.collection("names");

// Create
  Future<void> addName(String name) {
    return names.add({'name': name, 'timestamp': Timestamp.now()});
  }

// Read
  Stream<QuerySnapshot> getNameStream() {
    final namesStream =
        names.orderBy('timestamp', descending: true).snapshots();
    return namesStream;
  }

//Update

  Future<void> updateName(String docId, String newName) {
    return names
        .doc(docId)
        .update({'name': newName, 'timestamp': Timestamp.now()});
  }

//Delete

  Future<void> deleteName(String docId) {
    return names.doc(docId).delete();
  }
}
