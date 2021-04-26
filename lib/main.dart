import 'package:flutter/material.dart';

void main() {
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

  @override
  void initState() {
    todos.add("item 1");
    todos.add("item 2");
    todos.add("item 3");
    super.initState();
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
                title: Text("Add Task"),
                content: TextField(
                  onChanged: (String value) {
                    input = value;
                  },
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        todos.add(input);
                      });
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
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todos[index]),
            child: Card(
              elevation: 4.0,
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(todos[index]),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      todos.removeAt(index);
                    });
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
      ),
    );
  }
}
