import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.orange,
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todos = [];
  String input = "";

  createToDos() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(input);

    Map<String, dynamic> todos = {"todosTitle": input};

    documentReference.set(todos).whenComplete(() => print("$input created"));
  }

  deleteToDos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);

    documentReference.delete().whenComplete(
          () => print("Deleted"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Planner"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                title: Text("Add Task"),
                content: TextField(
                  onChanged: (String value) {
                    input = value;
                  },
                ),
                actions: [
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      createToDos();
                      Navigator.pop(context);
                    },
                    child: Text("Add"),
                  )
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('MyTodos').snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Text('PLease Wait')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                    itemBuilder: (context, index) {
                      Todo todoItem =
                          Todo.fromdocument(snapshot.data.docs[index]);
                      return Dismissible(
                        key: Key(index.toString()),
                        child: Card(
                          elevation: 4.0,
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(todoItem.title),
                            trailing: IconButton(
                              onPressed: () {
                                deleteToDos(todoItem.title);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }),
    );
  }
}

// ListView.builder(
//             shrinkWrap: true,
//             itemCount: snapshot.data.documents.length,
//             itemBuilder: (context, index) {
//               DocumentSnapshot documentSnapshot =
//                   snapshot.data.documents[index];
//               return Dismissible(
//                 key: Key(index.toString()),
//                 child: Card(
//                   elevation: 4.0,
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text(documentSnapshot["todoTitle"]),
//                     trailing: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           todos.removeAt(index);
//                         });
//                       },
//                       icon: Icon(Icons.delete),
//                       color: Colors.red,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
