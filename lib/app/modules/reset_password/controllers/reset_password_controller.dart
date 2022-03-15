import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void errMsg(String message) {
    Get.snackbar("Terjadi Kesalahan", message);
  }

  void resetPass() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.back();
        Get.snackbar("Berhasil",
            "Kami Telah mengirim link untuk reset password ke email anda");
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        errMsg(e.code);
      } catch (e) {
        isLoading.value = false;
        errMsg(e.toString());
      }
    } else {
      errMsg("Email tidak boleh kosong");
    }
  }
}
