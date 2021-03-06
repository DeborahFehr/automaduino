import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

// https://pub.dev/packages/scrollable_text_view

// TO DO: add line numbers

// if using HTML:
// https://stackoverflow.com/questions/41306797/html-how-to-add-line-numbers-to-a-source-code-block

class GeneratedCode extends StatefulWidget {

  @override
  _GeneratedCodeState createState() => _GeneratedCodeState();
}

class _GeneratedCodeState extends State<GeneratedCode> {
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
          alignment: Alignment.bottomLeft,
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
