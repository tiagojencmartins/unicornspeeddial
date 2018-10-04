import 'package:flutter/material.dart';

//import 'package:unicorndial/unicorndial.dart';
import 'unicorn.dart';

void main() =>
    runApp(new MaterialApp(debugShowCheckedModeBanner: false, home: Example()));

class Example extends StatefulWidget {
  _Example createState() => _Example();
}

class _Example extends State<Example> {
  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Choo choo",
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: Colors.redAccent,
          mini: false,
          child: Icon(Icons.train),
          onPressed: () {
            print("asdaads");
          },
        )));

    var N = UnicornDialer(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
        parentButtonBackground: Colors.redAccent,
        hasBackground: false,
        hasNotch: true,
        //isDocked: true,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: childButtons);

    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          //shape: CircularNotchedRectangle(),

          child: new Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: N,
        appBar: AppBar(),
        body: Center(child: RaisedButton(
          onPressed: () {
            setState(() {});
          },
        )));
  }
}
