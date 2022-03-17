import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myfirebase/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class ProfileController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool imageProf = false.obs;
  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;
  XFile? image;
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
      imageProf.value = true;
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

        await firestore.collection("users").doc(uid).update({
          "name": nameC.text,
          "phone": phoneC.text,
        });
        String ext = image!.name.split(".").last;

        print(ext);
        if (image != null) {
          await storage
              .ref(uid)
              .child("profile.$ext")
              .putFile(File(image!.path));

          String imgUrl =
              await storage.ref(uid).child("profile.$ext").getDownloadURL();

          await firestore
              .collection("users")
              .doc(uid)
              .update({"image": imgUrl});
        }
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

  void addImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      update();
    }
  }

  void clearImage() async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection("users")
        .doc(uid)
        .update({"image": FieldValue.delete()});
    imageProf.value = false;
    update();
    Get.back();
  }

  void resetImage() async {
    image = null;
    update();
  }
}
