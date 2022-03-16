import 'package:flutter/material.dart';

import 'package:get/get.dart';
import "package:intl/intl.dart";

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProfileView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getProfile(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.data == null) {
              return Center(
                child: Text('Tidak ada data'),
              );
            } else {
              controller.emailC.text = snap.data!['email'];
              controller.nameC.text = snap.data!['name'];
              controller.phoneC.text = snap.data!['phone'];

              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  TextField(
                    controller: controller.nameC,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    readOnly: true,
                    controller: controller.emailC,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.phoneC,
                    keyboardType: TextInputType.phone,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.passC,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    obscureText: controller.isHidden.value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffix: IconButton(
                            onPressed: () {
                              controller.isHidden.toggle();
                            },
                            icon: Icon(Icons.remove_red_eye_sharp))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create_At",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(DateFormat.yMMMMd()
                      .add_Hm()
                      .format(DateTime.parse(snap.data!["created_at"]))),
                  ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller.updateProfile();
                        }
                      },
                      child: Obx(() => Text(
                          controller.isLoading.isFalse ? "Update" : "Loading")))
                ],
              );
            }
          }),
    );
  }
}
