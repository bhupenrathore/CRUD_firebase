import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebase/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();

  void openDialogBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                decoration: const InputDecoration(hintText: 'Enter Name'),
                controller: nameController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docId == null) {
                        firestoreService.addName(nameController.text);
                      } else {
                        firestoreService.updateName(docId, nameController.text);
                      }
                      nameController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text("Name List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openDialogBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firestoreService.getNameStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List namesList = snapshot.data!.docs;
            return ListView.builder(
                itemCount: namesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = namesList[index];
                  String docId = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String nameText = data['name'];
                  return ListTile(
                    title: Text(nameText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => openDialogBox(docId: docId),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => firestoreService.deleteName(docId),
                        )
                      ],
                    ),
                  );
                });
          } else {
            return const Text('Add names here...');
          }
        },
      ),
    );
  }
}
