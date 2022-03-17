import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditNoteController extends GetxController {
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getNotes(String uid) async {
    try {
      String id = auth.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> dataNote = await firestore
          .collection("users")
          .doc(id)
          .collection("notes")
          .doc(uid)
          .get();
      return dataNote.data();
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal Mengambil Data");
      return null;
    }
  }

  void editNotes(String UID) async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String id = auth.currentUser!.uid;
        await firestore
            .collection("users")
            .doc(id)
            .collection("notes")
            .doc(UID)
            .update({"title": titleC.text, "desc": descC.text});
        isLoading.value = false;
        Get.back();
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "${e}");
        Get.back();
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Data tidak boleh kosong");
      isLoading.value = false;
      Get.back();
    }
  }
}
