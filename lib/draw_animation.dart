import 'dart:math';

import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  const MyDrawer({Key? key, required this.child, required this.drawer})
      : super(key: key);

  @override
  State<MyDrawer> createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  late AnimationController _xControllerChild;
  late Animation<double> _yRotationAnimationForChild;
  late AnimationController _xControllerDrawer;
  late Animation<double> _yRotationAnimationForDrawer;

  bool _drawerOpen = false;

  @override
  void initState() {
    super.initState();
    _xControllerChild =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _yRotationAnimationForChild =
        Tween<double>(begin: 0, end: -pi / 2).animate(_xControllerChild);

    _xControllerDrawer =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _yRotationAnimationForDrawer =
        Tween<double>(begin: pi / 2.7, end: 0).animate(_xControllerDrawer);
  }

  @override
  void dispose() {
    _xControllerChild.dispose();
    _xControllerDrawer.dispose();
    super.dispose();
  }

  /// Public method to open/close the drawer programmatically.
  void toggleDrawer() {
    if (_drawerOpen) {
      _xControllerChild.reverse();
      _xControllerDrawer.reverse();
    } else {
      _xControllerChild.forward();
      _xControllerDrawer.forward();
    }
    _drawerOpen = !_drawerOpen;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.9;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.delta.dx / maxDrag;
        _xControllerChild.value += delta;
        _xControllerDrawer.value += delta;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerChild.value < 0.5) {
          _xControllerChild.reverse();
          _xControllerDrawer.reverse();
          _drawerOpen = false;
        } else {
          _xControllerChild.forward();
          _xControllerDrawer.forward();
          _drawerOpen = true;
        }
      },
      child: AnimatedBuilder(
          animation: Listenable.merge([_xControllerDrawer, _xControllerChild]),
          builder: (context, child) {
            return Stack(
              children: [
                // child background
                Container(color: Colors.transparent),

                // main child (DefaultSongs)
                Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) //  cascade operator (..)
                    ..translate(_xControllerChild.value * maxDrag)
                    ..rotateY(_yRotationAnimationForChild.value),
                  child: widget.child,
                ),

                // drawer (SpecialSongs)
                Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(
                        -screenWidth + _xControllerDrawer.value * maxDrag)
                    ..rotateY(_yRotationAnimationForDrawer.value),
                  child: widget.drawer,
                ),
              ],
            );
          }),
    );
  }
}
