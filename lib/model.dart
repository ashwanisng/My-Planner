import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Todo {
  String title;

  Todo({this.title});

  factory Todo.fromdocument(DocumentSnapshot ds) {
    return Todo(
      title: ds.data()['todosTitle'] ?? 'Error',
    );
  }
}
