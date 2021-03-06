import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RegisterView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nameC,
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Nama",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.emailC,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.phoneC,
            autocorrect: false,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.passC,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.isLoading.isFalse) {
                controller.register();
              }
            },
            child: Obx(() =>
                Text(controller.isLoading.isFalse ? "Register" : "Loading...")),
          ),
        ],
      ),
    );
  }
}
