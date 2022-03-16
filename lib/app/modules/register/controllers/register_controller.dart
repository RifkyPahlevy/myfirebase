import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfirebase/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void errMsg(String message) {
    Get.snackbar("Terjadi Kesalahan", message);
  }

  void register() async {
    if (emailC.text.isNotEmpty &&
        passC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        phoneC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        isLoading.value = false;
        await userCredential.user!.sendEmailVerification();

        //insert data user
        firestore.collection("users").doc(userCredential.user!.uid).set({
          "email": emailC.text,
          "name": nameC.text,
          "phone": phoneC.text,
          "uid": userCredential.user!.uid,
          "created_at": DateTime.now().toIso8601String()
        });

        Get.snackbar(
            "Email Verification", "Kami Telah Mengirim Email Verifikasi");
        Get.offAllNamed(Routes.LOGIN);
      } on FirebaseAuthException catch (e) {
        isLoading.value = true;
        errMsg("${e.code}");
      } catch (e) {
        errMsg(e.toString());
      }
    } else {
      errMsg("Semua tidak boleh kosong");
    }
  }
}
