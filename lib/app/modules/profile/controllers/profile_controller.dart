import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myfirebase/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController passC = TextEditingController();

  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat logout");
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      String uid = auth.currentUser!.uid;
      var dataUser = await firestore.collection("users").doc(uid).get();
      return dataUser.data();
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengambil data");
      return null;
    }
    return null;
  }

  void updateProfile() async {
    isLoading.value = true;
    try {
      if (nameC.text.isNotEmpty &&
          emailC.text.isNotEmpty &&
          phoneC.text.isNotEmpty) {
        String uid = await auth.currentUser!.uid;

        var dataUser = await firestore.collection("users").doc(uid).update({
          "name": nameC.text,
          "phone": phoneC.text,
        });

        if (passC.text.isNotEmpty) {
          if (passC.text.length >= 6) {
            await auth.currentUser!.updatePassword(passC.text);
            await auth.signOut();
            Get.offAllNamed(Routes.LOGIN);
            isLoading.value = false;
          } else {
            Get.snackbar(
                "Terjadi Kesalahan", "Password harus lebih dari 6 karakter");
            isLoading.value = false;
          }
        }
        isLoading.value = false;
        Get.back();
      } else {
        Get.snackbar("Terjadi Kesalahan", "Semua tidak boleh kosong");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat update data");
      isLoading.value = false;
    }
  }
}
