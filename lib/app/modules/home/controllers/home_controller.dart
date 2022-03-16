import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllNotes() async* {
    String uid = auth.currentUser!.uid;

    yield* await firestore
        .collection("users")
        .doc(uid)
        .collection("notes")
        .orderBy("createAt", descending: true)
        .snapshots();
  }
}
