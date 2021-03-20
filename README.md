# UnicornDialer

Easily create your own floating action button list

![alt text](https://github.com/tiagojencmartins/unicornspeeddial/blob/master/vertical.gif?raw=true)

![alt text](https://github.com/tiagojencmartins/unicornspeeddial/blob/master/horizontal.gif?raw=true)


## Installing

Add UnicornDialer to your **pubspec.yaml**

```
unicorndial: "^1.1.5"
```

## Options ##

**UnicornDialer class**

`int orientation` - **Vertical or horizontal floating button list**

`Object parentHeroTag` - **Main FAB hero tag**

`Color backgroundColor` - **Modal background color**

` Icon parentButton` - **Starting Icon**

` Icon finalButtonIcon` - **Ending Icon (after animation is complete)**

` bool hasBackground` - **Background modal is set**

` Color parentButtonBackground` - **The main floating button background color**

 `List<UnicornButton> childButtons` **Floating button list**

 `int animationDuration` **Rotation and expanding animation duration (in milliseconds)**

 `double childPadding` - **Right padding on the button label**

 `Function onMainButtonPressed` - **To be called if set on the UnicornDialer parent widget**

 `bool hasNotch` - **BottomAppBar support**



 **UnicornButton class**

 `FloatingActionButton currentButton` - **Floating list button**

 `String labelText`

 `double labelFontSize`

 `Color labelColor`

 `Color labelBackgroundColor`

 `Color labelShadowColor` - **Label container shadow**

 `bool labelHasShadow`

 `bool hasLabel`


## NestedFAB Support ##
To use nested fab, check the following code

```
child: Scaffold(
    ...
    ...
    // FloatingActionButton is a NestedFab which is a list of UnicornDialers
    
    floatingActionButton: NestedFab(
    parentButtonBackground: Colors.grey[700],
    orientation: UnicornOrientation.HORIZONTAL,
    backgroundColor: Colors.black38,
    parentButtonIcon: Icon(Icons.person),
    children: _getProfileMenu(),
    ),
),


List<UnicornDialer> _getProfileMenu() {
  List<UnicornDialer> children = [
    UnicornDialer(
      parentButtonBackground: Colors.grey[700],
      backgroundColor: Colors.transparent,
      parentButton: Icon(Icons.add),
      childButtons: [
        FloatingActionButton(
          backgroundColor: Colors.grey[700],
          mini: true,
          heroTag: "bankTag",
          child: Icon(Icons.account_balance),
          onPressed: () {
            print("bank");
          },
        ),
      ],
    ),
    UnicornDialer(
      parentButtonBackground: Colors.grey[700],
      backgroundColor: Colors.transparent,
      parentButton: Icon(Icons.settings),
      childButtons: [
        FloatingActionButton(
          backgroundColor: Colors.grey[700],
          mini: true,
          heroTag: "phoneTag",
          child: Icon(Icons.phone),
          onPressed: () {
            print("phone");
          },
        ),
      ],
    )
  ];
  return children;
}
```


## Authors

**Tiago Martins**


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
