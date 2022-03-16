import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  TextEditingController titleC = TextEditingController();
  TextEditingController desC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addNotes() async {
    if (titleC.text.isNotEmpty && desC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String uid = await auth.currentUser!.uid;
        await firestore.collection("users").doc(uid).collection("notes").add({
          "title": titleC.text,
          "desc": desC.text,
          "createAt": DateTime.now().toIso8601String()
        });

        isLoading.value = false;
        Get.back();
      } catch (e) {
        print(e);
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "Title dan Description tidak boleh kosong");
    }
  }
}
