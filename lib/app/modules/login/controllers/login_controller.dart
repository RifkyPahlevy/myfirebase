import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myfirebase/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  RxBool isRememberMe = false.obs;
  final box = GetStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  void errMsg(String message) {
    Get.snackbar("Terjadi Kesalahan", message);
  }

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        isLoading.value = true;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        print(userCredential);
        isLoading.value = false;

        if (userCredential.user!.emailVerified == true) {
          if (box.read("rememberme") != null) {
            box.remove("rememberme");
          }
          if (isRememberMe.isTrue) {
            box.write("rememberme", {
              "email": emailC.text,
              "pass": passC.text,
            });
          }

          Get.offAllNamed(Routes.HOME);
        } else {
          Get.defaultDialog(
              title: "Email Verification",
              middleText: " Apakah kamu ingin Kirim Ulang Email verifikasi?",
              actions: [
                OutlinedButton(
                    onPressed: () {
                      try {
                        userCredential.user!.sendEmailVerification();
                        Get.snackbar("Email Verikasi",
                            "Kami Telah Mengirim Email Verifikasi");
                        Get.back();
                      } catch (e) {
                        errMsg(e.toString());
                      }
                    },
                    child: Text("Okay")),
                OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("Tidak")),
              ]);
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        errMsg(e.message.toString());
      }
    }
  }
}
