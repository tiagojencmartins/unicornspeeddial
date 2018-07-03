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
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
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
  final bool rotateMain;
  final Icon parentButton;
  final parentButtonBackground;
  final List<UnicornButton> childButtons;
  final int animationDuration;
  final double childPadding;
  final Function onMainButtonPressed;

  UnicornDialer(
      {this.parentButton,
        this.parentButtonBackground,
        this.childButtons,
        this.onMainButtonPressed,
        this.rotateMain = true,
        this.orientation = 1,
        this.animationDuration = 300,
        this.childPadding = 4.0})
      : assert(parentButton != null),
        assert(childButtons != null),
        assert(childButtons.length > 0);

  _UnicornDialer createState() => _UnicornDialer();
}

class _UnicornDialer extends State<UnicornDialer>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _childAnimation;
  var isChildOpen = false;

  @override
  void initState() {
    this._animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.animationDuration))
      ..addListener(() {
        this.isChildOpen = !this._animationController.isDismissed;
        setState(() {
          this.isChildOpen;
        });
      });

    this._childAnimation = Tween<double>(
        begin: 0.0,
        end: -50.0)
        .animate(CurvedAnimation(
        parent: this._animationController,
        curve: Interval(0.0, 0.75, curve: Curves.easeIn)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final collapsedState = UnicornButtonInherit.of(context);
    if (collapsedState.isCollapsed && widget.rotateMain) {
      this._animationController.reverse();
    }

    Widget mainFloatingButton = widget.parentButton;
    if (widget.rotateMain) {
      mainFloatingButton = AnimatedBuilder(
          animation: this._animationController,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(
                angle: this._animationController.value * 0.8,
                child: widget.parentButton);
          });
    }

    var childButtonsList = List.generate(widget.childButtons.length, (index) {
      return Container(
          padding: widget.orientation == UnicornOrientation.VERTICAL
              ? EdgeInsets.only(bottom: widget.childPadding, right: 4.0)
              : EdgeInsets.only(left: widget.childPadding),
          child: Transform(
              transform: Matrix4.translationValues(
                  widget.orientation == UnicornOrientation.HORIZONTAL
                      ? this._childAnimation.value *
                      ((widget.childButtons.length - index))
                      : 0.0,
                  widget.orientation == UnicornOrientation.VERTICAL
                      ? this._childAnimation.value *
                      ((widget.childButtons.length - index))
                      : 0.0,
                  0.0),
              child: widget.childButtons[index].label != null &&
                  widget.orientation == UnicornOrientation.VERTICAL
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  this.isChildOpen
                      ? Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: widget.childButtons[index].label)
                      : Container(),
                  widget.childButtons[index].currentButton
                ],
              )
                  : Padding(
                  padding: EdgeInsets.only(bottom: 4.0, right: widget.orientation == UnicornOrientation.VERTICAL ? 0.0 : 6.0),
                  child: widget.childButtons[index].currentButton)));
    });

    var speedDialWidget = childButtonsList.toList()
      ..add(Container(
          child: FloatingActionButton(
              backgroundColor: widget.parentButtonBackground,
              onPressed: () {
                if (widget.onMainButtonPressed != null) {
                  widget.onMainButtonPressed();
                }

                if (widget.rotateMain) {
                  if (this._animationController.isDismissed) {
                    this._animationController.forward();
                  } else {
                    this._animationController.reverse();
                  }
                }
              },
              child: mainFloatingButton)));

    return Stack(
        alignment: FractionalOffset.bottomRight,
        //mainAxisSize: MainAxisSize.min,
        //crossAxisAlignment: CrossAxisAlignment.end,
        //mainAxisAlignment: MainAxisAlignment.end,
        children: speedDialWidget);
  }
}
