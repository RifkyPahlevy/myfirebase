import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfirebase/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void errMsg(String message) {
    Get.snackbar("Terjadi Kesalahan", message);
  }

  void register() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        isLoading.value = false;
        await userCredential.user!.sendEmailVerification();
        Get.defaultDialog(
            title: "Email Verifikasi",
            middleText:
                "Kami telah mengirimkan email verifikasi ke email anda Silahkan Cek email yang terdaftar",
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Text("Okay"))
            ]);
      } on FirebaseAuthException catch (e) {
        print(e.code);
      } catch (e) {
        print(e);
      }
    } else {
      errMsg("Email dan Password tidak boleh kosong");
    }
  }
}
