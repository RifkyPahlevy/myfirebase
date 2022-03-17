import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myfirebase/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[400],
                  );
                }
                Map<String, dynamic>? dataProfile = snapshot.data!.data();
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.PROFILE),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    backgroundImage: NetworkImage(dataProfile!["image"] != null
                        ? snapshot.data!.data()!["image"]
                        : "https://ui-avatars.com/api/?name=Rifky Pahlevy"),
                  ),
                );
              }),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamAllNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var dataNote = snapshot.data!.docs[index];
                var note = dataNote.data();
                return ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.EDIT_NOTE, arguments: dataNote.id),
                  trailing: IconButton(
                      onPressed: () => controller.deleteNote(dataNote.id),
                      icon: Icon(Icons.delete)),
                  title: Text("${note['title']}"),
                  subtitle: Text("${note['desc']}"),
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_NOTE),
        child: Icon(Icons.add),
      ),
    );
  }
}
