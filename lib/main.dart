import 'package:flutter/material.dart';

import './models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  List items = new List<Item>();

  HomePage() {
    items = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskController = TextEditingController();

  void addTodo() {
    if (newTaskController.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(
        title: newTaskController.text,
        done: false,
      ));
      newTaskController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          cursorColor: Colors.white,
          autofocus: true,
          controller: newTaskController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: 'Novo Todo',
            labelStyle: TextStyle(color: Colors.grey[100]),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_box,
              color: Colors.white,
              size: 34,
            ),
            padding: EdgeInsets.only(left: 20.0, right: 30.0),
            onPressed: addTodo,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];

          return CheckboxListTile(
            title: Text(item.title),
            key: Key(item.title),
            value: item.done,
            onChanged: (bool value) {
              setState(() {
                item.done = value;
              });
            },
          );
        },
      ),
    );
  }
}
