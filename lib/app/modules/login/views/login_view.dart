import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myfirebase/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    if (box.read("rememberme") != null) {
      controller.emailC.text = box.read("rememberme")["email"];
      controller.passC.text = box.read("rememberme")["pass"];
      controller.isRememberMe.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() => TextField(
              controller: controller.passC,
              obscureText: controller.isHidden.value,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                suffix: IconButton(
                  onPressed: () => controller.isHidden.toggle(),
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ))),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.isLoading.isFalse) {
                controller.login();
              }
            },
            child: Obx(() =>
                Text(controller.isLoading.isFalse ? "Login" : "Loading...")),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() => CheckboxListTile(
                value: controller.isRememberMe.value,
                onChanged: (value) {
                  controller.isRememberMe.toggle();
                },
                title: Text("Remember me"),
                controlAffinity: ListTileControlAffinity.leading,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
                child: Text("Forgot Password?"),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.REGISTER);
              },
              child: Text("Register"))
        ],
      ),
    );
  }
}
