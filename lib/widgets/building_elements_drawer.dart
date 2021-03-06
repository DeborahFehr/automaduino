import 'package:flutter/material.dart';

// TO DO: Vertical Text
// https://stackoverflow.com/questions/58310795/flutter-vertical-text-widget

class BuildingElementsDrawer extends StatefulWidget {
  final int flexWidth; // TO DO: unsure if this is needed...
  void updateWidth;

  BuildingElementsDrawer({Key key, @required this.flexWidth, @required this.updateWidth}) : super(key: key);

  @override
  _BuildingElementsDrawerState createState() => _BuildingElementsDrawerState();
}

class _BuildingElementsDrawerState extends State<BuildingElementsDrawer> {
  double _width = 500;
  Color _color = Colors.green;
  bool closed = false;

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
            width: 50,
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
                    child: Text('Ok'),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.yellow,
                      elevation: 5,
                    ),
                    onPressed: () {
                      setState(() {
                        _width = (_width > 50) ? 50 : 500;
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
