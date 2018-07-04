import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

void main() =>
    runApp(new MaterialApp(debugShowCheckedModeBanner: false, home: Example()));

class Example extends StatefulWidget {
  _Example createState() => _Example();
}

class _Example extends State<Example> {
  var isCollapsed = false;

  Function onActionButtonTap({bool status}) {
    setState(() {
      this.isCollapsed = status == null ? !this.isCollapsed : status;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ChildButtons = List<UnicornButton>();

    ChildButtons.add(UnicornButton(
        label: Chip(
            backgroundColor: Colors.redAccent,
            label: Text("Choo choo", style: TextStyle(color: Colors.white))),
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.train),
          onPressed: () {
            onActionButtonTap(status: true);
          },
        )));

    ChildButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "airplane",
            backgroundColor: Colors.greenAccent,
            mini: true,
            child: Icon(Icons.airplanemode_active))));

    ChildButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "directions",
            backgroundColor: Colors.blueAccent,
            mini: true,
            child: Icon(Icons.directions_car))));

    return Scaffold(
        floatingActionButton: UnicornButtonInherit(
            onTap: onActionButtonTap,
            isCollapsed: this.isCollapsed,
            child: UnicornDialer(
                backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
                parentButtonBackground: Colors.redAccent,
                orientation: UnicornOrientation.HORIZONTAL,
                parentButton: Icon(Icons.add),
                childButtons: ChildButtons)),
        appBar: AppBar(),
        body: Center(child: FlutterLogo(size: 100.0)));
  }
}
