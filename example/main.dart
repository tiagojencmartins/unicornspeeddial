import 'package:flutter/material.dart';
import '../lib/unicorndial.dart';

void main() => runApp(new MaterialApp(home: Example()));

class Example extends StatefulWidget {
  _Example createState() => _Example();
}

class _Example extends State<Example> {
  @override
  Widget build(BuildContext context) {
    var ChildButtons = List<UnicornButton>();
    var PersonChildButtons = List<UnicornButton>();

    PersonChildButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            mini: true, child: Icon(Icons.pregnant_woman))));

    ChildButtons.add(UnicornButton(
        label: Chip(
            backgroundColor: Colors.redAccent,
            label: Text("Add new", style: TextStyle(color: Colors.white))),
        currentButton:
        FloatingActionButton(mini: true, child: Icon(Icons.people))));

    ChildButtons.add(UnicornButton(
        currentButton:
        FloatingActionButton(mini: true, child: Icon(Icons.home))));

    return Scaffold(
        floatingActionButton: UnicornDialer(
          parentButtonBackground: Colors.redAccent,
          orientation: UnicornOrientation.HORIZONTAL,
          parentButton: Icon(Icons.add),
          childButtons: ChildButtons,
        ),
        appBar: AppBar(),
        body: Text("hi"));
  }
}