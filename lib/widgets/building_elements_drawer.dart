import 'package:flutter/material.dart';

// TODO: Vertical Text
// https://stackoverflow.com/questions/58310795/flutter-vertical-text-widget

class BuildingElementsDrawer extends StatefulWidget {
  final double expandedWidth;
  Function(bool closed) updateWidth;

  BuildingElementsDrawer({Key key, @required this.expandedWidth, @required this.updateWidth}) : super(key: key);

  @override
  _BuildingElementsDrawerState createState() => _BuildingElementsDrawerState();
}

class _BuildingElementsDrawerState extends State<BuildingElementsDrawer> {
  double _width;
  Color _color = Colors.green;
  bool closed = false;

  void initState() {
    super.initState();
    _width = widget.expandedWidth;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: _width,
        decoration: BoxDecoration(
          color: _color,
        ),
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        child: Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            // Alternate: Use Button Theme?
            width: widget.expandedWidth / 4,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: closed ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 750),
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    child: Text('>'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.yellow,
                      elevation: 5,
                    ),
                    onPressed: () {
                      setState(() {
                        _width = closed ? widget.expandedWidth : widget.expandedWidth / 4;
                        widget.updateWidth(closed);
                        closed = !closed;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
