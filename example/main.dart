import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

void main() => runApp(new MaterialApp(home: Example()));

class Example extends StatefulWidget {
  _Example createState() => _Example();
}

class _Example extends State<Example> {
  var isCollapsed = false;

  Function onChildTap() {
    this.isCollapsed = true;
    setState(() {
      this.isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ChildButtons = List<UnicornButton>();

    ChildButtons.add(UnicornButton(
        label: Chip(
            backgroundColor: Colors.redAccent,
            label: Text("Add new", style: TextStyle(color: Colors.white))),
        currentButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.people),
          onPressed: () {
            onChildTap();
          },
        )));

    ChildButtons.add(UnicornButton(
        currentButton:
        FloatingActionButton(mini: true, child: Icon(Icons.home))));

    return Scaffold(
        floatingActionButton: UnicornButtonInherit(
            onTap: onChildTap,
            isCollapsed: this.isCollapsed,
            child: UnicornDialer(
                parentButtonBackground: Colors.redAccent,
                orientation: UnicornOrientation.VERTICAL,
                parentButton: Icon(Icons.add),
                childButtons: ChildButtons
            )),
        appBar: AppBar(),
        body: Center(child: FlutterLogo(size: 100.0)));
  }
}
