import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
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
      saveTodo();
    });
  }

  void removeTodo(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
    saveTodo();
  }

  Future loadTodos() async {
    var preferences = await SharedPreferences.getInstance();
    var data = preferences.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((item) => Item.fromJson(item)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  saveTodo() async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: TextField(
          cursorColor: Colors.white,
          controller: newTaskController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            focusColor: Colors.white,
            labelText: 'Novo Todo',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
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

          return Dismissible(
            direction: DismissDirection.startToEnd,
            key: Key(item.title),
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (bool value) {
                setState(() {
                  item.done = value;
                });
                saveTodo();
              },
              activeColor: Colors.green,
            ),
            onDismissed: (direction) {
              removeTodo(index);
            },
            background: Container(
              color: Colors.red.withOpacity(0.6),
              child: Text(
                "Remover",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              padding: EdgeInsets.only(
                left: 12.0,
                top: 18.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
