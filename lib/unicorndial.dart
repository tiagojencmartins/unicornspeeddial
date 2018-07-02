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
      : assert(parentButton != null);

  _UnicornDialer createState() => _UnicornDialer();
}

class _UnicornDialer extends State<UnicornDialer>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    this._animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animationDuration));
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
          child: ScaleTransition(
              alignment: FractionalOffset.center,
              scale: new CurvedAnimation(
                parent: this._animationController,
                curve: new Interval(0.0, 1.0 - index / 20.0 / 2.0,
                    curve: Curves.easeOut),
              ),
              child: widget.childButtons[index].label != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: widget.childButtons[index].label),
                        widget.childButtons[index].currentButton
                      ],
                    )
                  : widget.childButtons[index].currentButton));
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
                  this._animationController.isDismissed
                      ? this._animationController.forward()
                      : this._animationController.reverse();
                }
              },
              child: mainFloatingButton)));

    return widget.orientation == UnicornOrientation.VERTICAL
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: speedDialWidget)
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: speedDialWidget);
  }
}
