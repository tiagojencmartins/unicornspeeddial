import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class NestedFab extends StatefulWidget {
  final List<UnicornDialer> children;
  final FloatingActionButton parentButton;
  final int orientation;
  final Icon parentButtonIcon;
  final Icon finalButtonIcon;
  final bool hasBackground;
  final Color parentButtonBackground;
  final double childPadding;
  final Color backgroundColor;
  final Function onMainButtonPressed;
  final Object parentHeroTag;
  final bool hasNotch;

  NestedFab(
      {this.parentButton,
      this.parentButtonBackground,
      this.children,
      this.parentButtonIcon,
      this.onMainButtonPressed,
      this.orientation = UnicornOrientation.HORIZONTAL,
      this.hasBackground = true,
      this.backgroundColor = Colors.white30,
      this.parentHeroTag = "parent",
      this.finalButtonIcon,
      this.childPadding = 4.0,
      this.hasNotch = false})
      : assert(children != null);

  @override
  State<NestedFab> createState() => _NestedFabState();
}

class _NestedFabState extends State<NestedFab> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _parentController;

  bool isOpen = false;

  @override
  void initState() {
    this._animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 180,
      ),
    );

    this._parentController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    );

    super.initState();
  }

  @override
  dispose() {
    this._animationController.dispose();
    this._parentController.dispose();
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
    this._animationController.reverse();

    var hasChildButtons = widget.children != null && widget.children.length > 0;

    // set the orientation of the children opposite to that of the parent
    if (hasChildButtons) {
      for (UnicornDialer dialer in widget.children) {
        dialer.orientation = widget.orientation == UnicornOrientation.VERTICAL
            ? UnicornOrientation.HORIZONTAL
            : UnicornOrientation.VERTICAL;
      }
    }

    if (!this._parentController.isAnimating) {
      if (this._parentController.isCompleted) {
        this._parentController.forward().then((s) {
          this._parentController.reverse().then((e) {
            this._parentController.forward();
          });
        });
      }
      if (this._parentController.isDismissed) {
        this._parentController.reverse().then((s) {
          this._parentController.forward();
        });
      }
    }

    var mainFAB = AnimatedBuilder(
      animation: this._parentController,
      builder: (
        BuildContext context,
        Widget child,
      ) {
        return Transform(
          transform: new Matrix4.diagonal3(
            vector.Vector3(
              _parentController.value,
              _parentController.value,
              _parentController.value,
            ),
          ),
          alignment: FractionalOffset.center,
          child: FloatingActionButton(
            isExtended: false,
            heroTag: "parent",
            backgroundColor: widget.parentButtonBackground,
            onPressed: () {
              mainActionButtonOnPressed();
              if (widget.onMainButtonPressed != null) {
                widget.onMainButtonPressed();
              }
            },
            child: !hasChildButtons
                ? widget.parentButtonIcon
                : AnimatedBuilder(
                    animation: this._animationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: new Matrix4.rotationZ(
                            this._animationController.value * 0.8),
                        alignment: FractionalOffset.center,
                        child: this._animationController.isDismissed
                            ? widget.parentButtonIcon
                            : new Icon(
                                widget.finalButtonIcon == null
                                    ? Icons.close
                                    : widget.finalButtonIcon.icon,
                              ),
                      );
                    },
                  ),
          ),
        );
      },
    );

    if (hasChildButtons) {
      var mainFloatingButton = AnimatedBuilder(
        animation: this._animationController,
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
            angle: this._animationController.value * 0.8,
            child: mainFAB,
          );
        },
      );

      var childButtonsList =
          widget.children == null || widget.children.length == 0
              ? List<Widget>()
              : List.generate(
                  widget.children.length,
                  (index) {
                    var intervalValue = index == 0
                        ? 0.9
                        : ((widget.children.length - index) /
                                widget.children.length) -
                            0.2;

                    intervalValue =
                        intervalValue < 0.0 ? (1 / index) * 0.5 : intervalValue;

                    return Positioned(
                      right: widget.orientation == UnicornOrientation.VERTICAL
                          ? 4.0
                          : ((widget.children.length - index) * 55.0) + 15,
                      bottom: widget.orientation == UnicornOrientation.VERTICAL
                          ? ((widget.children.length - index) * 55.0) + 15
                          : 4.0,
                      child: Container(
                        width: widget.orientation == UnicornOrientation.VERTICAL
                            ? 300
                            : 40,
                        height:
                            widget.orientation == UnicornOrientation.VERTICAL
                                ? 40
                                : 300,
                        child: ScaleTransition(
                          scale: CurvedAnimation(
                            parent: this._animationController,
                            curve: Interval(
                              intervalValue,
                              1.0,
                              curve: Curves.linear,
                            ),
                          ),
                          alignment: FractionalOffset.bottomRight,
                          child: widget.children[index],
                        ),
                      ),
                    );
                  },
                );

      var unicornDialWidget = Container(
        margin: widget.hasNotch ? EdgeInsets.only(bottom: 15.0) : null,
        height: double.infinity,
        width: widget.orientation == UnicornOrientation.HORIZONTAL
            ? ((widget.children.length * 60) + 100).toDouble()
            : 300,
        child: Stack(
          //fit: StackFit.expand,
          alignment: Alignment.bottomRight,
          overflow: Overflow.visible,
          children: childButtonsList.toList()
            ..add(
              Positioned(
                right: null,
                bottom: null,
                child: mainFloatingButton,
              ),
            ),
        ),
      );

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
          ),
        ),
      );

      return widget.hasBackground
          ? Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: [
                Positioned(right: -16.0, bottom: -16.0, child: modal),
                unicornDialWidget
              ],
            )
          : unicornDialWidget;
    }
    return mainFAB;
  }
}
