import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_note_controller.dart';

class EditNoteView extends GetView<EditNoteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EditNoteView'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getNotes(Get.arguments.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null) {
              return Center(
                child: Text("Tidak ada data"),
              );
            } else {
              controller.titleC.text = snapshot.data!["title"];
              controller.descC.text = snapshot.data!["desc"];
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  TextField(
                    controller: controller.titleC,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: controller.descC,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller.editNotes(Get.arguments.toString());
                        }
                      },
                      child: Obx(() => Text(controller.isLoading.isFalse
                          ? "Edit note"
                          : "loading..."))),
                ],
              );
            }
          }),
    );
  }
}
