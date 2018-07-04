import 'package:flutter/material.dart';

class UnicornOrientation {
  static const HORIZONTAL = 0;
  static const VERTICAL = 1;
}

class UnicornButtonInherit extends InheritedWidget {
  final Function onTap;
  final bool isCollapsed;

  const UnicornButtonInherit({
    Key key,
    this.onTap,
    this.isCollapsed,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static UnicornButtonInherit of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(UnicornButtonInherit);
  }

  @override
  bool updateShouldNotify(UnicornButtonInherit oldWidget) {
    return oldWidget.isCollapsed != this.isCollapsed;
  }
}

class UnicornButton extends StatelessWidget {
  final FloatingActionButton currentButton;
  final Chip label;

  UnicornButton({this.currentButton, this.label})
      : assert(currentButton != null);

  @override
  Widget build(BuildContext context) {
    return this.currentButton;
  }
}

class UnicornDialer extends StatefulWidget {
  final int orientation;
  final Icon parentButton;
  final parentButtonBackground;
  final List<UnicornButton> childButtons;
  final int animationDuration;
  final double childPadding;
  final Color backgroundColor;
  final Function onMainButtonPressed;

  UnicornDialer(
      {this.parentButton,
        this.parentButtonBackground,
        this.childButtons,
        this.onMainButtonPressed,
        this.orientation = 1,
        this.backgroundColor = Colors.redAccent,
        this.animationDuration = 180,
        this.childPadding = 4.0})
      : assert(parentButton != null),
        assert(childButtons != null),
        assert(childButtons.length > 0);

  _UnicornDialer createState() => _UnicornDialer();
}

class _UnicornDialer extends State<UnicornDialer>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool isOpen = false;
  bool triggered = false;

  @override
  void initState() {
    this._animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.animationDuration))
      ..addListener(() {});

    super.initState();
  }

  @override
  dispose() {
    this._animationController.dispose();
    super.dispose();
  }

  void mainActionButtonOnPressed() {
    if (this._animationController.isDismissed) {
      this._animationController.forward();
    } else {
      this._animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final collapsedState = UnicornButtonInherit.of(context);
    if (collapsedState.isCollapsed) {
      mainActionButtonOnPressed();
    }

    Widget mainFloatingButton = widget.parentButton;

    mainFloatingButton = AnimatedBuilder(
        animation: this._animationController,
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
              angle: this._animationController.value * 0.8,
              child: widget.parentButton);
        });

    var childButtonsList = List.generate(widget.childButtons.length, (index) {
      var intervalValue = index == 0
          ? 0.9
          : ((widget.childButtons.length - index) /
          widget.childButtons.length) -
          0.2;

      intervalValue = intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue ;

      return Positioned(
          right: widget.orientation == UnicornOrientation.VERTICAL
              ? 15.0
              : ((widget.childButtons.length - index) * 55.0),
          bottom: widget.orientation == UnicornOrientation.VERTICAL
              ? ((widget.childButtons.length - index) * 55.0)
              : 0.0,
          child: Container(
            padding: EdgeInsets.only(
                bottom: widget.orientation == UnicornOrientation.VERTICAL
                    ? 18.0
                    : 15.0,
                right: widget.orientation == UnicornOrientation.VERTICAL
                    ? 4.0
                    : 15.0),
            child: Row(children: [
              ScaleTransition(
                  scale: CurvedAnimation(
                    parent: this._animationController,
                    curve: Interval(intervalValue, 1.0, curve: Curves.linear),
                  ),
                  alignment: FractionalOffset.center,
                  child: (widget.childButtons[index].label == null) ||
                      widget.orientation == UnicornOrientation.HORIZONTAL
                      ? Container()
                      : Padding(
                      padding: EdgeInsets.only(right: widget.childPadding),
                      child: widget.childButtons[index].label)),
              ScaleTransition(
                  scale: CurvedAnimation(
                    parent: this._animationController,
                    curve: Interval(intervalValue, 1.0, curve: Curves.linear),
                  ),
                  alignment: FractionalOffset.center,
                  child: widget.childButtons[index].currentButton)
            ]),
          ));
    });

    var unicornDialWidget = Stack(
        children: childButtonsList.toList()
          ..add(Positioned(
              right: 12.0,
              bottom: 12.0,
              child: FloatingActionButton(
                  backgroundColor: widget.parentButtonBackground,
                  onPressed: mainActionButtonOnPressed,
                  child: mainFloatingButton))));

    var modal = ScaleTransition(
        scale: CurvedAnimation(
          parent: this._animationController,
          curve: Interval(1.0, 1.0, curve: Curves.linear),
        ),
        alignment: FractionalOffset.center,
        child: GestureDetector(
            onTap: mainActionButtonOnPressed,
            child: Container(
              color: widget.backgroundColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )));

    return Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: [
          Positioned(right: -16.0, bottom: -16.0, child: modal),
          unicornDialWidget
        ]);
  }
}